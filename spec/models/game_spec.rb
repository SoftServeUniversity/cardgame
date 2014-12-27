require 'rails_helper'

describe Game do
  before(:example) do
  	@game = Game.new
  	@game.init
  	@game.init_state
  	@user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
    @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
  end

  describe  "init_state" do
  	it "should switch to NewGame" do
  		expect(@game.state_name).to eq("NewGame")
  		@game.init_player @user
  		expect(@game.state_name).to eq("ExpectationOfSecondPlayer")
  		@game.init_player @user2
  		expect(@game.state_name).to eq("GamePrepare")
  	end

    it "should switch to ExpectationOfSecondPlayer" do
      @game.init_player @user
      expect(@game.state_name).to eq("ExpectationOfSecondPlayer")
    end

    it "should switch to GamePrepare" do
      @game.init_player @user
      @game.init_player @user2
      expect(@game.state_name).to eq("GamePrepare")    
    end

    it "should switch to another player's move" do
      @game.init_player @user
      @game.init_player @user2
      @game.prepare_game_to_start
      if @game.attacker.user_id == @game.players[0].user_id
        expect(@game.state_name).to eq("MoveOfFirstPlayer")
      else
        expect(@game.state_name).to eq("MoveOfSecondPlayer")
      end
    end
  end

  describe "set_game_state" do
  	it "should set states" do
  		@game.set_game_state(ExpectationOfSecondPlayer.new @game)
  		expect(@game.state_name).to eq("ExpectationOfSecondPlayer")
#
  		@game.set_game_state(BreakTurn.new @game)
      expect(@game.state_name).to eq("BreakTurn")
  	end
  end

  describe  "do_init_first_player" do
  	it "should init_first player" do
  		@game.do_init_first_player @user
  		expect(@game.players[0].user_id).to eq(@user.id)
  	end
  end
end

describe Game do
  before(:example) do
  	@game = Game.new
  	@game.init
  	@game.init_state
  	@user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
    @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
    @game.do_init_first_player @user
  	@game.do_init_second_player @user2
  	@card = Card.new("hearts", 4)
  	@game.do_preparation_for_game
  end

  describe  "do_init_second_player" do
  	it "should init_second player" do
  		expect(@game.players[1].user_id).to eq(@user2.id)
  	end
  end

  describe "do_preparation_for_game" do
  	it "should prepare game" do
  		expect(@game.table).to_not eq(nil)
  		expect(@game.deck).to_not eq(nil)
  		expect(@game.deck.deck_cards.length).to eq(36)
  	end
  end

  describe "do_get_card_from_player" do
  	it "should get card from player" do
  		@game.table.add_card(@card, @game.players[0], @game.players[0])
  		expect(@game.table.table_cards[0]).to eq(@card)
  	end
  end

  describe  "do_end_turn" do
  	before(:example) do
  	  @att = @game.attacker
  	  expect(@att).to eq(@game.mover)
  	  @game.do_end_turn
  	  @att2 = @game.attacker 
  	end
  	it "should clear table" do
  		expect(@game.table.table_cards).to eq([])
  	end

  	it "should change mover" do
  		expect(@att).to_not eq(@att2)
  	end
  end

  describe "do_break_turn" do
  	before(:example) do
  	  @card = @game.players[0].player_cards[2]
  	  @game.table.add_card(@card, @game.players[0], @game.players[0])
  	  @game.do_break_turn 1
  	end
#
  	it "should send card from table to one" do
  	  expect(@game.players[0].player_cards.length).to eq(6)
  	  expect(@game.players[1].player_cards.length).to eq(7)
  	end

  	it "should clear table" do
  		expect(@game.table.table_cards).to eq([])
  	end
  end
end

describe Game do
  before(:example) do
    @game = Game.new
    @game.init
    @game.init_state
    @user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
    @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
    @game.do_init_first_player @user
    @game.do_init_second_player @user2
    @card = Card.new("hearts", 4)
    @game.table = Table.create({:game => @game, :cards_count => 0})
    @game.deck = Deck.create({:game => @game})
    @game.deck.init_cards
  end

  describe "init_players_cards" do
    before(:example) do
      expect(@game.players[0].player_cards).to eq([])
      expect(@game.players[1].player_cards).to eq([])
      @game.init_players_cards
    end
#
    it "should give 6 cards to each player" do
      expect(@game.players[0].player_cards.length).to eq(6)
      expect(@game.players[1].player_cards.length).to eq(6)
    end
  end

  describe "set_attacker" do
    before(:example) do
      @game.set_attacker
      @first_min = @game.find_smallest_trump @game.players[0]
      @second_min = @game.find_smallest_trump @game.players[1]
    end
#
    it "should set attacker" do
      if (@first_min != nil) && (@second_min == nil)
        expect(@game.attacker).to eq(@game.players[0])
      elsif (@first_min == nil) && (@second_min != nil)
        expect(@game.attacker).to eq(@game.players[1])
      elsif @first_min.rang < @second_min.rang
        expect(@game.attacker).to eq(@game.players[0])
      else
        expect(@game.attacker).to eq(@game.players[1])
      end
    end
  end

  describe "find_smallest_trump" do
    before(:example) do
      @game.init_players_cards
      @trump1 = @game.find_smallest_trump(@game.players[0])
      @trump2 = @game.find_smallest_trump(@game.players[1])
      @game2 = Game.new
      @game2.init
      @game2.init_state
      @game2.do_init_first_player @user
      @game2.do_init_first_player @user2
      @game2.deck = Deck.create({:game => @game2})
      @game2.players[0].player_cards[0] = Card.new("#{@game2.deck.trump}", 4)
      @game2.players[0].player_cards[1] = Card.new("#{@game2.deck.trump}", 1)
      @game2.players[0].player_cards[2] = Card.new("#{@game2.deck.trump}", 3)
      @game2.players[0].player_cards[3] = Card.new("#{@game2.deck.trump}", 5)
      @trump3 = @game2.find_smallest_trump @game2.players[0]
    end
#
    it "should find smallest trump" do
      expect(@trump3.rang).to eq(1)
      if @trump1 
        expect(@trump1.suite).to eq(@game.deck.trump)
      end
      if @trump2
        expect(@trump2.suite).to eq(@game.deck.trump)
      end
    end
  end
end