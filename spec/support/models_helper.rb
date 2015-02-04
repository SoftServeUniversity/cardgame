module ModelHelpers

  def deck_card_init(num , rang, suite)
    @deck.deck_cards[num] = build(:card, suite: suite, rang: rang)
  end

  def user_setup(name = NIL, email = NIL, &block)
    yield if block_given?

    @warden_condition = {login: name||email}
    @warden_condition.expects(:dup).returns({login: name||email})
    @warden_condition.expects(:delete).with(:login).returns(name||email)
  end

  def setup_user_for_database_auth(name = NIL, email = NIL)
    if name
      user_setup(name, NIL) do
        @user = create(:user, username: NAME_SAMPLE)
      end
    elsif email
      user_setup(NIL, email) do
        @user = create(:user, email: email)
      end
    end
  end

  def move_of_player?(mover)
    case mover
    when SECOND_PLAYER
      @game.mover == @game.players[NUMBER_ONE] && @game.state == MOVE_OF_SECOND_PLAYER
    when FIRST_PLAYER
      @game.mover == @game.players[NUMBER_ZERO] && @game.state == MOVE_OF_FIRST_PLAYER
    end
  end

  def make_a_move
    if @game.state == MOVE_OF_FIRST_PLAYER
      @game.get_card_from_player(@game.players[NUMBER_ZERO].player_cards[NUMBER_ZERO],
                                 @game.players[NUMBER_ZERO], @game.attacker)
    else
      @game.get_card_from_player(@game.players[NUMBER_ONE].player_cards[NUMBER_ZERO],
                                 @game.players[NUMBER_ONE], @game.attacker)
    end
  end

  def expect_game_state_right(number_str, number)
    expect(@game.state).to eq("move_of_#{number_str}_player")
    expect(@game.players[number].player_cards.length).to eq(NUMBER_FIVE)
  end

  def expect_depending_on_mover
    if move_of_player?(SECOND_PLAYER)
      expect_game_state_right(SECOND_PLAYER, NUMBER_ZERO)
    elsif move_of_player?(FIRST_PLAYER)
      expect_game_state_right(FIRST_PLAYER, NUMBER_ONE)
    end
  end

  def expect_end_turn(number_str, num)
    if @game.mover == @game.players[NUMBER_ZERO]
      if @game.players[num] == @game.attacker
        expect(@game.state).to eq("move_of_#{number_str}_player")
      else
        expect(@game.state).to eq(BREAK_TURN_STATE)
      end
    end
  end

  def create_and_put_card(num)
    @card1 = @game.players[num].player_cards[NUMBER_ONE]
    @game.get_card_from_player(@game.players[num].player_cards[NUMBER_ONE],
                               @game.players[num], @game.attacker )
  end

  def loop_to_find_trump(num)
    for i in NUMBER_ONE..NUMBER_FIVE
      if @game.players[num].player_cards[i].rang == @game.players[num].player_cards[NUMBER_ZERO].rang
        expect(@game.table.allow_attack? @game.players[num].player_cards[i]).to eq(TRUE)
      end
    end
  end

  def defend_card_rang_higher?(i, player)
    (@game.players[player].player_cards[i].rang > @card1.rang)
  end

  def defend_card_suite_same?(i, player)
    (@game.players[player].player_cards[i].suite == @card1.suite)
  end

  def defender_card_trump(i, player)
    (@game.players[player].player_cards[i].suite == @game.deck.trump)
  end

  def attacker_card_not_trump(i)
    (@card1.suite != @game.deck.trump)
  end

  def allow_defence_rules(i, player)
    defend_card_rang_higher?(i, player) && defend_card_suite_same?(i, player)
  end


  def allow_defence_rules_trump(i, player)
    defender_card_trump(i, player) && attacker_card_not_trump(i)
  end

  def loop_and_check_allow_defence(player)
    @cards = []
    for i in NUMBER_ZERO..NUMBER_FIVE
      if allow_defence_rules(i, player)
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(TRUE)
      elsif allow_defence_rules_trump(i, player)
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(TRUE)
      else
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(FALSE)
      end
    end
  end

  def loop_over_table_cards_check_presence
    @game.table.table_cards.each do |card|
      if card
        expect(@cards.include?(card)).to eq(TRUE)
      end
    end
  end

  def init_card_add_to_table_check_expectations(player, &block)
    @card1 = @game.players[player].player_cards[NUMBER_FOUR]
    expect(@game.table.add_card(@game.players[player].player_cards[NUMBER_FOUR],
                                @game.players[player], @game.attacker )).to eq(TRUE)
    expect(@game.table.cards_count).to eq(NUMBER_ONE)
    expect(@game.table.table_cards[NUMBER_ZERO]).to eq(@card1)
    yield if block_given?
  end


  def go_to_expectation_of_second
    @game = create(:game)
    @user = create(:user)
    @game.do_init_first_player @user
  end

  def go_to_game_prepare_state(&block)
    go_to_expectation_of_second
    @user2 = create(:user)
    @game.do_init_second_player @user2
    yield @game if block_given?
  end

  def find_trump_for_both
    @first_min = @game.find_smallest_trump @game.players[NUMBER_ZERO]
    @second_min = @game.find_smallest_trump @game.players[NUMBER_ONE]
  end

  def init_card_deck_table
    @card = build(:card)
    @game.table = create(:table)
    @game.deck = create(:deck)
    @game.deck.init_cards
  end

  def iterate_and_push_cards
    @cards = []
    for i in NUMBER_ZERO..NUMBER_THREE
      @game.table.do_push_card( @game.players[NUMBER_ONE].player_cards[i],
                                @game.players[NUMBER_ONE], @game.attacker)
      @cards.push(@game.players[NUMBER_ONE].player_cards[i])
    end
  end

  def creating_some_trumps
    for i in NUMBER_ZERO..NUMBER_THREE
      @game2.players[NUMBER_ZERO].player_cards[i] = build(:card,
                                                suite:"#{@game2.deck.trump}",
                                                rang: i + NUMBER_ONE)
    end
  end

  def iterate_cards_for_trump(player)
    @game.players[player].player_cards.each do |card|
      if card.suite == @game.deck.trump
        expect(@game.table.trump? card).to eq(TRUE)
      end
    end
  end

  def create_second_game
    @game2 = create(:game)
    @game2.do_init_first_player @user
    @game2.do_init_second_player @user2
    @game2.deck = create(:deck)
  end

  def expect_defend_or_attack(status)
    if @game.send("#{status}er".to_sym) == @game.mover
      expect(@game.table.send("#{status}?".to_sym)).to eq(TRUE)
    else
      expect(@game.table.send("#{status}?".to_sym)).to eq(FALSE)
    end
  end

end

RSpec.configure do |config|
  config.include ModelHelpers, :type => :model
end
