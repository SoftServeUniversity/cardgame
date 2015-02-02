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
    it "should put_cards" do
      if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
        @card1 = @game.players[1].player_cards[1]
        @game.get_card_from_player(@game.players[1].player_cards[1], @game.players[1], @game.attacker )
        expect(@game.table.put_cards[0]).to eq(@card1)
      elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
        @card2 = @game.players[0].player_cards[1]
        @game.get_card_from_player(@game.players[0].player_cards[1], @game.players[0], @game.attacker)
        expect(@game.table.put_cards[0]).to eq(@card2)
      end
    end
  end

  describe  "get_latest_card" do
    it "should pick latest card" do
      if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
        @card1 = @game.players[1].player_cards[1]
        @game.get_card_from_player(@game.players[1].player_cards[1], @game.players[1], @game.attacker )

        expect(@game.table.get_latest_card).to eq(@card1)
      elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
        @card2 = @game.players[0].player_cards[1]
        @game.get_card_from_player(@game.players[0].player_cards[1], @game.players[0], @game.attacker)

        expect(@game.table.get_latest_card).to eq(@card2)
      end
    end
  end

  describe  "allow_attack?" do
    it "should alow attack" do
      if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
        expect(@game.table.allow_attack? @game.players[1].player_cards[0]).to eq(true)
        for i in 1..5 do
            if @game.players[1].player_cards[i].rang == @game.players[1].player_cards[0].rang
              expect(@game.table.allow_attack? @game.players[1].player_cards[i]).to eq(true)
            end
          end
          else
            expect(@game.table.allow_attack? @game.players[0].player_cards[0]).to eq(true)
            for i in 1..5 do
                if @game.players[0].player_cards[i].rang == @game.players[0].player_cards[0].rang
                  expect(@game.table.allow_attack? @game.players[0].player_cards[i]).to eq(true)
                end
              end
            end
          end
        end

        describe  "allow_defend?" do
          it "should alow defend" do
            if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
              @card1 = @game.players[1].player_cards[1]
              @game.get_card_from_player(@game.players[1].player_cards[1], @game.players[1], @game.attacker )
              for i in 0..5 do
                  if (@game.players[0].player_cards[i].rang > @card1.rang) && (@game.players[0].player_cards[i].suite == @card1.suite)
                    expect(@game.table.allow_defend? @game.players[0].player_cards[i]).to eq(true)
                  elsif (@game.players[0].player_cards[i].suite == @game.deck.trump) && (@card1.suite != @game.deck.trump)
                    expect(@game.table.allow_defend? @game.players[0].player_cards[i]).to eq(true)
                  else
                    expect(@game.table.allow_defend? @game.players[0].player_cards[i]).to eq(false)
                  end
                end
                else
                  @card2 = @game.players[0].player_cards[1]
                  @game.get_card_from_player(@game.players[0].player_cards[1], @game.players[0], @game.attacker )
                  for i in 0..5 do
                      if (@game.players[1].player_cards[i].rang > @card2.rang) && (@game.players[1].player_cards[i].suite == @card2.suite)
                        expect(@game.table.allow_defend? @game.players[1].player_cards[i]).to eq(true)
                      elsif (@game.players[1].player_cards[i].suite == @game.deck.trump) && (@card2.suite != @game.deck.trump)
                        expect(@game.table.allow_defend? @game.players[1].player_cards[i]).to eq(true)
                      else
                        expect(@game.table.allow_defend? @game.players[1].player_cards[i]).to eq(false)
                      end
                    end
                  end
                end
              end

              describe  "do_push_card" do
                it "should push to the table" do
                  @cards = []

                  for i in 0..3
                    @game.table.do_push_card @game.players[1].player_cards[i] , @game.players[1], @game.attacker
                    @cards.push(@game.players[1].player_cards[i])
                  end

                  if @game.players[1] == @game.attacker
                    @game.table.table_cards.each do |card|
                      if card != nil
                        expect(@cards.include?(card)).to eq(true)
                      end
                    end
                    expect(@game.table.cards_count).to eq(4)
                    expect(@game.table.attacker_cursor).to eq(8)
                  else
                    @game.table.table_cards.each do |card|
                      if card != nil
                        expect(@cards.include?(card)).to eq(true)
                      end
                    end
                    expect(@game.table.cards_count).to eq(4)
                    expect(@game.table.defender_cursor).to eq(9)
                  end
                end
              end

              describe  "add_card" do
                it "should add_card check if possible and push to table" do
                  if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
                    @card1 = @game.players[1].player_cards[4]

                    expect(@game.table.add_card(@game.players[1].player_cards[4], @game.players[1], @game.attacker )).to eq(true)
                    expect(@game.table.add_card(@game.players[0].player_cards[4], @game.players[0], @game.attacker )).to eq(false)
                    expect(@game.table.cards_count).to eq(1)
                    expect(@game.table.table_cards[0]).to eq(@card1)
                  elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
                    @card2 = @game.players[0].player_cards[4]

                    expect(@game.table.add_card(@game.players[0].player_cards[4], @game.players[0], @game.attacker )).to eq(true)
                    expect(@game.table.cards_count).to eq(1)
                    expect(@game.table.table_cards[0]).to eq(@card2)
                  end
                end
              end
            end
