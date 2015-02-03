module ModelHelpers

  def deck_card_init(num , rang, suite)
    @deck.deck_cards[num] = build(:card, suite: suite, rang: rang)
  end

  def user_setup(name = nil, email = nil, &block)
    if block_given?
      yield
    end
    @warden_condition = {login: name||email}
    @warden_condition.expects(:dup).returns({login: name||email})
    @warden_condition.expects(:delete).with(:login).returns(name||email)
  end

  def setup_user_for_database_auth(name = nil, email = nil)
    if name
      user_setup(name, nil) do
        @user = create(:user, username: "villy")
      end
    elsif email
      user_setup(nil, email) do
        @user = create(:user, email: email)
      end
    end
  end

  def move_of_player?(mover)
    case mover
    when 'second'
      @game.mover == @game.players[1] && @game.state == "move_of_second_player"
    when 'first'
      @game.mover == @game.players[0] && @game.state == "move_of_first_player"
    end
  end

  def make_a_move
    if @game.state == "move_of_first_player"
      @game.get_card_from_player(@game.players[0].player_cards[0],
                                 @game.players[0], @game.attacker)
    else
      @game.get_card_from_player(@game.players[1].player_cards[0],
                                 @game.players[1], @game.attacker)
    end
  end

  def expect_game_state_right(number_str, number)
    expect(@game.state).to eq("move_of_#{number_str}_player")
    expect(@game.players[number].player_cards.length).to eq(5)
  end

  def expect_depending_on_mover
    if move_of_player?("second")
      expect_game_state_right("second", 0)
    elsif move_of_player?("first")
      expect_game_state_right("first", 1)
    end
  end

  def expect_end_turn(number_str, num)
    if @game.mover == @game.players[0]
      if @game.players[num] == @game.attacker
        expect(@game.state).to eq("move_of_#{number_str}_player")
      else
        expect(@game.state).to eq("break_turn")
      end
    end
  end

  def create_and_put_card(num)
    @card1 = @game.players[num].player_cards[1]
    @game.get_card_from_player(@game.players[num].player_cards[1],
                               @game.players[num], @game.attacker )
  end

  def loop_to_find_trump(num)
    for i in 1..5
      if @game.players[num].player_cards[i].rang == @game.players[num].player_cards[0].rang
        expect(@game.table.allow_attack? @game.players[num].player_cards[i]).to eq(true)
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
    for i in 0..5
      if allow_defence_rules(i, player)
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(true)
      elsif allow_defence_rules_trump(i, player)
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(true)
      else
        expect(@game.table.allow_defend? @game.players[player].player_cards[i]).to eq(false)
      end
    end
  end

  def loop_over_table_cards_check_presence
    @game.table.table_cards.each do |card|
      if card
        expect(@cards.include?(card)).to eq(true)
      end
    end
  end

  def init_card_add_to_table_check_expectations(player, &block)
    @card1 = @game.players[player].player_cards[4]
    expect(@game.table.add_card(@game.players[player].player_cards[4],
                                @game.players[player], @game.attacker )).to eq(true)
    expect(@game.table.cards_count).to eq(1)
    expect(@game.table.table_cards[0]).to eq(@card1)
    if block_given?
      yield
    end
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
    if block_given?
      yield @game
    end
  end

  def find_trump_for_both
    @first_min = @game.find_smallest_trump @game.players[0]
    @second_min = @game.find_smallest_trump @game.players[1]
  end

  def init_card_deck_table
    @card = build(:card)
    @game.table = create(:table)
    @game.deck = create(:deck)
    @game.deck.init_cards
  end

  def iterate_and_push_cards
    @cards = []
    for i in 0..3
      @game.table.do_push_card( @game.players[1].player_cards[i],
                                @game.players[1], @game.attacker)
      @cards.push(@game.players[1].player_cards[i])
    end
  end

  def creating_some_trumps
    for i in 0..3
      @game2.players[0].player_cards[i] = build(:card,
                                                suite:"#{@game2.deck.trump}",
                                                rang: i+1)
    end
  end

  def iterate_cards_for_trump(player)
    @game.players[player].player_cards.each do |card|
      if card.suite == @game.deck.trump
        expect(@game.table.trump? card).to eq(true)
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
      expect(@game.table.send("#{status}?".to_sym)).to eq(true)
    else
      expect(@game.table.send("#{status}?".to_sym)).to eq(false)
    end
  end

end

RSpec.configure do |config|
  config.include ModelHelpers, :type => :model
end
