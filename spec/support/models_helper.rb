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

  def iterate_cards_for_trump(player)
    @game.players[player].player_cards.each do |card|
      if card.suite == @game.deck.trump
        expect(@game.table.trump? card).to eq(true)
      end
    end
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
