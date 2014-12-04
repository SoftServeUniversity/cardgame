class Player < ActiveRecord::Base

  serialize :player_cards, Array

  belongs_to :game
  belongs_to :user

  def put_card _rang, _suite
    card = self.player_cards[0]
    puts "???????????????????????     #{_rang} _____ #{_suite}"
    if self.cards_count > 0
      self.player_cards.each do |elem|
        puts "____________________     #{elem.rang} _____ #{elem.suite}"
        if ((elem.rang.to_f == _rang.to_f) && (elem.suite.to_s == _suite.to_s))
          card = elem
        end
      end
    else
      puts 'Empty'
    end
    card
  end

  def delete_card _card
    puts "======================="
    puts _card.rang
    puts _card.suite
    puts "======================="
    for i in 0...self.player_cards.length do
      puts self.player_cards[i].rang
      puts self.player_cards[i].suite

      if ((self.player_cards[i].rang.to_i == _card.rang.to_i) && (self.player_cards[i].suite.to_s == _card.suite.to_s))

        puts self.player_cards.delete_at(i)
        self.cards_count -= 1
        puts "____________________________DELETED"
        break
      end
    end
  end

  def init
    if !self.cards_count
      self.cards_count = 0
    end
  end

  def add_card new_card
    puts "??????????????????? add_card"
    puts new_card.rang
    puts new_card.suite
    init
    self.player_cards.push new_card
    self.cards_count  += 1
  end
end
