require 'rails_helper'
require 'pry'

describe Game do
  before(:each) do
    @game = create(:game)
    @user = create(:user)
    @user2 = create(:user)
  end

  describe  "init_state" do
    it "should switch to NewGame" do

      expect(@game.state).to eq(NEW_GAME_STATE)

      @game.do_init_first_player @user
      expect(@game.state).to eq(EXPECTATION_SECOND_PLAYER)

      @game.do_init_second_player @user2
      expect(@game.state).to eq(GAME_PREPARE_STATE)
    end

    it "should switch to ExpectationOfSecondPlayer" do
      @game.do_init_first_player @user

      expect(@game.state).to eq(EXPECTATION_SECOND_PLAYER)
    end

    it "should switch to GamePrepare" do
      @game.do_init_first_player @user
      @game.do_init_second_player @user2

      expect(@game.state).to eq("game_prepare")
    end

    it "should switch to another player's move" do
      @game.do_init_first_player @user
      @game.do_init_second_player @user2
      @game.do_preparation_for_game

      if @game.attacker.user_id == @game.players[NUMBER_ZERO].user_id
        expect(@game.state).to eq(MOVE_OF_FIRST_PLAYER)
      else
        expect(@game.state).to eq(MOVE_OF_SECOND_PLAYER)
      end
    end
  end

  describe  "do_init_first_player" do
    it "should init_first player" do
      @game.do_init_first_player @user

      expect(@game.players[NUMBER_ZERO].user_id).to eq(@user.id)
    end
  end
end

describe Game do
  before(:each) do
    go_to_game_prepare_state do
      @card = build(:card)
      @game.do_preparation_for_game
    end
  end

  describe  "do_init_second_player" do
    it "should init_second player" do
      expect(@game.players[NUMBER_ONE].user_id).to eq(@user2.id)
    end
  end

  describe "do_preparation_for_game" do
    it "should prepare game" do
      expect(@game.table).to_not be_nil
      expect(@game.deck).to_not be_nil
      expect(@game.deck.deck_cards.length).to eq(NUMBER_36)
    end
  end

  describe "do_get_card_from_player" do
    it "should get card from player" do
      @game.table.add_card(@card, @game.players[NUMBER_ZERO],
                           @game.players[NUMBER_ZERO])

      expect(@game.table.table_cards[NUMBER_ZERO]).to eq(@card)
    end
  end

  describe  "do_end_turn" do
    before(:each) do
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
    before(:each) do
      @card = @game.players[NUMBER_ZERO].player_cards[NUMBER_TWO]
      @game.table.add_card(@card, @game.players[NUMBER_ZERO],
                           @game.players[NUMBER_ZERO])
      @game.do_break_turn NUMBER_ONE
    end

    it "should send card from table to one" do
      expect(@game.players[NUMBER_ZERO].player_cards.length).to eq(NUMBER_SIX)
      expect(@game.players[NUMBER_ONE].player_cards.length).to eq(NUMBER_SEVEN)
    end

    it "should clear table" do
      expect(@game.table.table_cards).to eq([])
    end
  end
end

describe Game do
  before(:each) do
    go_to_game_prepare_state do
      init_card_deck_table
    end
  end

  describe "init_players_cards" do
    it "players decks should be empty" do
      expect(@game.players[NUMBER_ZERO].player_cards).to eq([])
      expect(@game.players[NUMBER_ONE].player_cards).to eq([])
    end

    it "should give 6 cards to first player" do
      @game.init_players_cards
      expect(@game.players[NUMBER_ZERO].player_cards.length).to eq(NUMBER_SIX)

      @game.players[NUMBER_ZERO].player_cards.each do |card|
        expect(card).to be_kind_of(Card)
      end
    end

    it "should give 6 cards to each player" do
      @game.init_players_cards
      expect(@game.players[NUMBER_ONE].player_cards.length).to eq(NUMBER_SIX)

      @game.players[NUMBER_ONE].player_cards.each do |card|
        expect(card).to be_kind_of(Card)
      end
    end
  end

  describe "set_attacker" do
    before(:each) do
      @game.set_attacker
      find_trump_for_both
    end

    it "should set attacker" do
      if @first_min  &&  !@second_min 
        expect(@game.attacker).to eq(@game.players[NUMBER_ZERO])
      elsif !@first_min &&  @second_min
        expect(@game.attacker).to eq(@game.players[NUMBER_ONE])
      elsif @first_min.rang < @second_min.rang
        expect(@game.attacker).to eq(@game.players[NUMBER_ZERO])
      else
        expect(@game.attacker).to eq(@game.players[NUMBER_ONE])
      end
    end
  end

  describe "find_smallest_trump" do
    before(:each) do
      @game.init_players_cards
      find_trump_for_both

      create_second_game
      creating_some_trumps
      @third_min = @game2.find_smallest_trump @game2.players[NUMBER_ZERO]
    end

    it "should find smallest trump" do
      expect(@third_min.rang).to eq(NUMBER_ONE)
      if @trump1
        expect(@first_min.suite).to eq(@game.deck.trump)
      end
      if @trump2
        expect(@second_min.suite).to eq(@game.deck.trump)
      end
    end
  end
end
