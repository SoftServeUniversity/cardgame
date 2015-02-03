require 'rails_helper'

describe Table do
  before(:each) do
    go_to_game_prepare_state do
      @game.do_preparation_for_game
    end
  end

  describe  "#trump?" do
    it "should compare for trump" do
      iterate_cards_for_trump(0)

      iterate_cards_for_trump(1)
    end
  end

  describe  "table_empty?" do
    it "should inspect table for emptyness" do
      expect(@game.table.table_empty?).to eq(true)
    end
  end

  describe  "defend?" do
    it "should return bool if player now defender" do
      expect_defend_or_attack("defend")
    end
  end

  describe  "attack?" do
    it "should return bool if player now attacker" do
      expect_defend_or_attack("attack")
    end
  end

  describe  "clear" do
    before(:each) do
      make_a_move
    end
    it "should first initialize array with card" do

      expect(@game.table.table_cards).to_not eq([])
      expect(@game.table.cards_count).to eq(1)
    end
    it "should clear array and counter" do
      @game.table.clear

      expect(@game.table.table_cards).to eq([])
      expect(@game.table.cards_count).to eq(0)
    end
  end

  describe  "put_cards" do
    it "should put_cards depending on mover" do
      if move_of_player?("second")
        create_and_put_card(1)

        expect(@game.table.put_cards[0]).to eq(@card1)
      elsif move_of_player?("first")
        create_and_put_card(0)

        expect(@game.table.put_cards[0]).to eq(@card1)
      end
    end
  end

  describe  "get_latest_card" do
    it "should pick latest card on mover" do
      if move_of_player?("second")
        create_and_put_card(1)

        expect(@game.table.get_latest_card).to eq(@card1)
      elsif move_of_player?("first")
        create_and_put_card(0)

        expect(@game.table.get_latest_card).to eq(@card1)
      end
    end
  end

  describe  "allow_attack?" do
    it "should alow attack" do
      if move_of_player?("second")
        expect(@game.table.allow_attack? @game.players[1].player_cards[0]).to eq(true)
        loop_to_find_trump(1)
      else
        expect(@game.table.allow_attack? @game.players[0].player_cards[0]).to eq(true)
        loop_to_find_trump(0)
      end
    end
  end

  describe  "allow_defend?" do
    it "should alow defend" do
      if move_of_player?("second")
        create_and_put_card(1)

        loop_and_check_allow_defence(0)
      else
        create_and_put_card(0)

        loop_and_check_allow_defence(1)
      end
    end
  end

  describe  "do_push_card" do
    it "should push to the table" do
      iterate_and_push_cards
      loop_over_table_cards_check_presence
      if @game.players[1] == @game.attacker
        expect(@game.table.cards_count).to eq(4)
        expect(@game.table.attacker_cursor).to eq(8)
      else
        expect(@game.table.cards_count).to eq(4)
        expect(@game.table.defender_cursor).to eq(9)
      end
    end
  end

  describe  "add_card" do
    it "should check if possible to add_card  and push to table" do
      if move_of_player?("second")
        init_card_add_to_table_check_expectations(1) do
          expect(@game.table.add_card(@game.players[0].player_cards[4],
                                      @game.players[0], @game.attacker )).to eq(false)
        end
      elsif move_of_player?("first")
        init_card_add_to_table_check_expectations(0)
      end
    end
  end
end
