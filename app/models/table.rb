class Table < ActiveRecord::Base

  serialize :table_cards, Array

  belongs_to :game

  def put_cards
    cards = self.table_cards
    clear
    cards
  end

  def clear
    self.table_cards = []
    self.cards_count = 0
    self.defender_cursor = ONE
    self.attacker_cursor = ZERO
  end

  def get_latest_card
    self.table_cards[self.cards_count-1]
  end

  def attack?
    self.game.attacker == self.game.mover
  end

  def defend?
    self.game.defender == self.game.mover
  end

  def table_empty?
    if self.cards_count > 0
      false
    else
      true
    end
  end

  def allow_attack? player_card
    allow_put = false
    if table_empty?
      allow_put = true
    else
      self.table_cards.each do |card|
        if card
          if card.rang.to_i == player_card.rang.to_i
            allow_put = true
          end
        end
      end
    end
    allow_put
  end

  def trump? card
    card.suite.to_s == self.game.deck.find_trump.to_s
  end

  def allow_defend? card
    allow_put = false
    if trump?(card) && !trump?(get_latest_card)
      allow_put = true
    elsif (card.suite.to_s == get_latest_card.suite.to_s) && (card.rang.to_i > get_latest_card.rang.to_i)
      allow_put = true
    end
    allow_put
  end

  def add_card _card, _player, _attacker
    allow = false
    if attack? && allow_attack?(_card)
      do_push_card _card, _player, _attacker
      allow = true
    elsif defend? && allow_defend?(_card)
      do_push_card _card, _player, _attacker
      allow = true
    end
    allow
  end

  def do_push_card _card, player, attacker
    if player == attacker
      self.table_cards[attacker_cursor] = _card
      self.attacker_cursor += 2
      self.cards_count  += 1
    else
      self.table_cards[defender_cursor] = _card
      self.defender_cursor += 2
      self.cards_count  += 1
    end
  end
end