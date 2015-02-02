require 'rails_helper'
describe :state do

  describe :new_game do
    before(:example) do
      @game = create(:game)
      @user = create(:user)
    end

    it "should initialize player" do
      @game.do_init_first_player @user

      expect(@game.players[0]).to be_kind_of(Player)
      expect(@game.players[0].user_id).to eq(@user.id)
      expect(@game.state).to eq("expactation_second_player")
    end
  end

  describe :expactation_second_player do
    before(:example) do
      @game = create(:game)
      @user = create(:user)
      @game.do_init_first_player @user
      @user2 = create(:user)
    end

    it "should initialize second player" do
      @game.do_init_second_player @user2

      expect(@game.players[1].user_id).to eq(@user2.id)
      expect(@game.state).to eq("game_prepare")
    end
  end


  describe :game_prepare do
    before(:example) do
      @game = create(:game)
      @user = create(:user)
      @game.do_init_first_player @user
      @user2 = create(:user)
      @game.do_init_second_player @user2
    end

    it "should do preparations" do
      @game.do_preparation_for_game

      expect(@game.table).to_not eq(nil)
      expect(@game.table).to be_kind_of(Table)
      expect(@game.deck).to_not eq(nil)
      expect(@game.deck).to  be_kind_of(Deck)

      if @game.mover == @game.players[0]
        expect(@game.state).to eq("move_of_first_player")
      else
        expect(@game.state).to eq("move_of_second_player")
      end
    end
  end

  describe :move_of_first_player do

    before(:example) do
      @game = create(:game)
      @game.do_init_first_player @user
      @game.do_init_second_player @user2
      @game.do_preparation_for_game
    end

    describe 'get_card_from_player' do

      it "should find out access rights player " do

        output = capture(:stdout) do
          if @game.state == "move_of_first_player"
            @game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
          else
            @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
          end
        end

        if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
          expect(@game.state).to eq("move_of_second_player")
          expect(@game.players[0].player_cards.length).to eq(5)
          expect(output).to include "Access granted"
        elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
          expect(@game.state).to eq("move_of_first_player")
          expect(@game.players[1].player_cards.length).to eq(5)
          expect(output).to include "Access granted"
        else
          expect(output).to include "Access denied"
        end
      end
    end

    describe 'end_turn' do

      it "should change state of game " do
        @game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
        @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
        @game.end_turn @game.players[1]

        if @game.mover == @game.players[0]
          if @game.players[1] == @game.attacker
            expect(@game.state).to eq("move_of_first_player")
          else
            expect(@game.state).to eq("break_turn")
          end
        end
      end
    end

  end

  describe :move_of_second_player do

    before(:example) do
      @game = create(:game)
      @game.do_init_first_player @user
      @game.do_init_second_player @user2
      @game.do_preparation_for_game
    end

    describe 'get_card_from_player' do
      it "should find out access rights player " do

        output = capture(:stdout) do
          if @game.state == "move_of_first_player"
            @game.get_card_from_player(@game.players[0].player_cards[0],
                                       @game.players[0], @game.attacker)
          else
            @game.get_card_from_player(@game.players[1].player_cards[0],
                                       @game.players[1], @game.attacker)
          end
        end

        if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
          expect(@game.state).to eq("move_of_second_player")
          expect(@game.players[0].player_cards.length).to eq(5)
          expect(output).to include "Access granted"
        elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
          expect(@game.state).to eq("move_of_first_player")
          expect(@game.players[1].player_cards.length).to eq(5)
          expect(output).to include "Access granted"
        else
          expect(output).to include "Access denied"
        end
      end
    end

    describe 'end_turn' do
      it "should change state of game " do
        @game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
        @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
        @game.end_turn @game.players[0]

        if @game.mover == @game.players[0]
          if @game.players[0] == @game.attacker
            expect(@game.state).to eq("move_of_second_player")
          else
            expect(@game.state).to eq("break_turn")
          end
        end

      end
    end
  end
end
