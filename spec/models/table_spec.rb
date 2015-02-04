require 'rails_helper'

describe Table do
  before(:each) do
    go_to_game_prepare_state do
      @game.do_preparation_for_game
    end
  end

  describe  "#trump?" do
    it "should compare for trump" do
      iterate_cards_for_trump(NUMBER_ZERO)

      iterate_cards_for_trump(NUMBER_ONE)
    end
  end

  describe  "table_empty?" do
    it "should inspect table for emptyness" do
      expect(@game.table.table_empty?).to eq(TRUE)
    end
  end

  describe  "defend?" do
    it "should return bool if player now defender" do
      expect_defend_or_attack(DEFEND)
    end
  end

  describe  "attack?" do
    it "should return bool if player now attacker" do
      expect_defend_or_attack(ATTACK)
    end
  end

  describe  "clear" do
    before(:each) do
      make_a_move
    end
    it "should first initialize array with card" do

      expect(@game.table.table_cards).to_not eq([])
      expect(@game.table.cards_count).to eq(NUMBER_ONE)
    end
    it "should clear array and counter" do
      @game.table.clear

      expect(@game.table.table_cards).to eq([])
      expect(@game.table.cards_count).to eq(NUMBER_ZERO)
    end
  end

  describe  "put_cards" do
    it "should put_cards depending on mover" do
      if move_of_player?(SECOND_PLAYER)
        create_and_put_card(NUMBER_ONE)

        expect(@game.table.put_cards[NUMBER_ZERO]).to eq(@card1)
      elsif move_of_player?(FIRST_PLAYER)
        create_and_put_card(NUMBER_ZERO)

        expect(@game.table.put_cards[NUMBER_ZERO]).to eq(@card1)
      end
    end
  end

  describe  "get_latest_card" do
    it "should pick latest card on mover" do
      if move_of_player?(SECOND_PLAYER)
        create_and_put_card(NUMBER_ONE)

        expect(@game.table.get_latest_card).to eq(@card1)
      elsif move_of_player?(FIRST_PLAYER)
        create_and_put_card(NUMBER_ZERO)

        expect(@game.table.get_latest_card).to eq(@card1)
      end
    end
  end

  describe  "allow_attack?" do
    it "should alow attack" do
      if move_of_player?(SECOND_PLAYER)
        expect(@game.table.allow_attack? @game.players[NUMBER_ONE].player_cards[NUMBER_ZERO]).to eq(true)
        loop_to_find_trump(NUMBER_ONE)
      else
        expect(@game.table.allow_attack? @game.players[NUMBER_ZERO].player_cards[NUMBER_ZERO]).to eq(true)
        loop_to_find_trump(NUMBER_ZERO)
      end
    end
  end

  describe  "allow_defend?" do
    it "should alow defend" do
      if move_of_player?(SECOND_PLAYER)
        create_and_put_card(NUMBER_ONE)

        loop_and_check_allow_defence(NUMBER_ZERO)
      else
        create_and_put_card(NUMBER_ZERO)

        loop_and_check_allow_defence(NUMBER_ONE)
      end
    end
  end

  describe  "do_push_card" do
    it "should push to the table" do
      iterate_and_push_cards
      loop_over_table_cards_check_presence
      if @game.players[NUMBER_ONE] == @game.attacker
        expect(@game.table.cards_count).to eq(NUMBER_FOUR)
        expect(@game.table.attacker_cursor).to eq(NUMBER_EIGHT)
      else
        expect(@game.table.cards_count).to eq(NUMBER_FOUR)
        expect(@game.table.defender_cursor).to eq(NUMBER_NINE)
      end
    end
  end

  describe  "add_card" do
    it "should check if possible to add_card  and push to table" do
      if move_of_player?(SECOND_PLAYER)
        init_card_add_to_table_check_expectations(NUMBER_ONE) do
          expect(@game.table.add_card(@game.players[NUMBER_ZERO].player_cards[NUMBER_FOUR],
                                      @game.players[NUMBER_ZERO], @game.attacker )).to eq(FALSE)
        end
      elsif move_of_player?(FIRST_PLAYER)
        init_card_add_to_table_check_expectations(NUMBER_ZERO)
      end
    end
  end
end
