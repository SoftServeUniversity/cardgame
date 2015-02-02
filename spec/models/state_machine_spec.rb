require 'rails_helper'
describe :state do
  before(:each) do
    go_to_expectation_of_second
  end

  describe :new_game do

    it "should initialize player" do

      expect(@game.players[0]).to be_kind_of(Player)
      expect(@game.players[0].user_id).to eq(@user.id)
      expect(@game.state).to eq("expactation_second_player")
    end
  end

  describe :expactation_second_player do
    before(:example) do
      @user2 = create(:user)
      @game.do_init_second_player @user2
    end

    it "should initialize second player" do
      expect(@game.players[1].user_id).to eq(@user2.id)
    end

    it "should trigger the state" do
      expect(@game.state).to eq("game_prepare")
    end
  end


  describe :game_prepare do
    before(:each) do
      go_to_game_prepare_state{|game| game.do_preparation_for_game}
    end

    it "should initialize table" do
      expect(@game.table).to_not eq(nil)
    end

    it "should create table with class Table" do
      expect(@game.table).to be_kind_of(Table)
    end

    it "should init deck" do
      expect(@game.deck).to_not eq(nil)
    end

    it "should create table with class Deck" do
      expect(@game.deck).to  be_kind_of(Deck)
    end

    it "should do preparations" do
      if @game.mover == @game.players[0]
        expect(@game.state).to eq("move_of_first_player")
      else
        expect(@game.state).to eq("move_of_second_player")
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
        2.times {make_a_move}
        @game.end_turn @game.players[1]

        expect_end_turn("first", 1)
      end
    end

  end

  describe :move_of_second_player do

    before(:example) do
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
        2.times {make_a_move}
        @game.end_turn @game.players[0]

        expect_end_turn("second", 0)

      end
    end
  end
end
