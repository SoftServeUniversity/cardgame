require 'rails_helper'
describe :state do
  before(:each) do
    go_to_expectation_of_second
  end

  describe :new_game do

    it "should initialize player" do

      expect(@game.players[NUMBER_ZERO]).to be_kind_of(Player)
      expect(@game.players[NUMBER_ZERO].user_id).to eq(@user.id)
      expect(@game.state).to eq(EXPECTATION_SECOND_PLAYER)
    end
  end

  describe :expactation_second_player do
    before(:each) do
      @user2 = create(:user)
      @game.do_init_second_player @user2
    end

    it "should initialize second player" do
      expect(@game.players[NUMBER_ONE].user_id).to eq(@user2.id)
    end

    it "should trigger the state" do
      expect(@game.state).to eq(GAME_PREPARE_STATE)
    end
  end


  describe :game_prepare do
    before(:each) do
      go_to_game_prepare_state{|game| game.do_preparation_for_game}
    end

    it "should initialize table" do
      expect(@game.table).to_not be_nil
    end

    it "should create table with class Table" do
      expect(@game.table).to be_kind_of(Table)
    end

    it "should init deck" do
      expect(@game.deck).to_not be_nil
    end

    it "should create table with class Deck" do
      expect(@game.deck).to  be_kind_of(Deck)
    end

    it "should do preparations" do
      if @game.mover == @game.players[NUMBER_ZERO]
        expect(@game.state).to eq(MOVE_OF_FIRST_PLAYER)
      else
        expect(@game.state).to eq(MOVE_OF_SECOND_PLAYER)
      end
    end
  end

  describe :move_of_first_player do

    before(:each) do
      go_to_game_prepare_state{|game| game.do_preparation_for_game}
    end

    describe 'get_card_from_player' do

      it "should find out access rights player " do

        make_a_move

        expect_depending_on_mover
      end
    end

    describe 'end_turn' do

      it "should change state of game " do
        NUMBER_TWO.times {make_a_move}
        @game.end_turn @game.players[NUMBER_ONE]

        expect_end_turn(FIRST_PLAYER, NUMBER_ONE)
      end
    end

  end

  describe :move_of_second_player do

    before(:each) do
      go_to_game_prepare_state{|game| game.do_preparation_for_game}
    end

    describe 'get_card_from_player' do
      it "should find out access rights player " do

        make_a_move

        expect_depending_on_mover
      end
    end

    describe 'end_turn' do
      it "should change state of game " do
        NUMBER_TWO.times {make_a_move}
        @game.end_turn @game.players[NUMBER_ZERO]

        expect_end_turn(SECOND_PLAYER, NUMBER_ZERO)

      end
    end
  end
end
