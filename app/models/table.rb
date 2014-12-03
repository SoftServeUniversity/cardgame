class Table < ActiveRecord::Base

  serialize :table_cards, Array

  belongs_to :game

  def put_cards
    cards = self.table_cards
    self.table_cards = []
    self.cards_count = 0
    cards
  end

  def get_latest_card
    self.table_cards[self.cards_count-1]
  end

  def attack? _player_id
    puts "*************************table atack?"
    self.game.attacker.to_i == self.game.mover.to_i
  end

  def defend? _player_id
    puts "*************************table defend?"
    self.game.defender.to_i == self.game.mover.to_i
  end

  def table_empty?
    if self.cards_count > 0
      false
    else
      true
    end
  end

  def allow_attack? _card
    puts "*************************table allow_atack?"
    @allow_put = false
    if table_empty?
      @allow_put = true
    else
      for card in self.table_cards do
          if card.rang.to_i == _card.rang.to_i
            @allow_put = true
          end
        end
      end
      puts "*************************table allow_atack?" + @allow_put.to_s
      @allow_put
    end

    def trump? _card
      puts "*************************table trump?"
      puts _card
      _card.suite.to_s == self.game.deck.find_trump.to_s
    end

    def allow_defend? _card
      puts "*************************table allow_defend?"
      @allow_put = false
      if trump?(_card) && !trump?(get_latest_card)
        @allow_put = true
      elsif (_card.suite.to_s == get_latest_card.suite.to_s) && (_card.rang.to_i > get_latest_card.rang.to_i)
         puts "************trump?(_card) && !trump?(get_latest_card)*************"
        @allow_put = true
      end
      @allow_put
    end

    def add_card _card, _player_id
      puts "table add_card************************"
      if attack?(_player_id) && allow_attack?(_card)
        do_push_card _card
        true
      elsif defend?(_player_id) && allow_defend?(_card)
        do_push_card _card
        true
      else
        false
      end
    end

    def do_push_card _card
      self.table_cards.push _card
      self.cards_count  += 1
    end
  end
