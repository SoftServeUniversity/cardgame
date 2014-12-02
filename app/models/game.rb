require "new_game"
require "deck"
require "card"

class Game < ActiveRecord::Base

 has_many :players
 has_one :deck
 has_one :table

 def init_state
    case self.state_name
    when 'NewGame'
     @state = NewGame.new self
    when 'ExpectationOfSecondPlayer'
     @state = ExpectationOfSecondPlayer.new self
    when 'GamePrepare'
     @state = GamePrepare.new self
    when 'MoveOfFirstPlayer'
     @state = MoveOfFirstPlayer.new self
    when 'MoveOfSecondPlayer'
     @state = MoveOfSecondPlayer.new self
    end
    @state
 end

 def set_game_state _state
  @state = _state
  self.state_name = _state.class.name
 end

 def init
  @state = NewGame.new(self)
 end

 def init_player _user
  @state.init_player _user
 end

 def prepare_game_to_start
  @state.prepare_game_to_start
 end

 def get_card_from_player _card, _player_id
  puts"Game.get_card_from_player __________________________________"
  @state.get_card_from_player _card, _player_id
 end

 def do_init_first_player _user
  puts "Doing init first player..."
  player = Player.create({:game => self, :user => _user})
  self.attacker = player.id
 end

 def do_init_second_player _user
  puts "Doing init second player..."
  player = Player.create({:game => self, :user => _user})
  self.defender = player.id
 end

 def do_preparation_for_game
  puts "Doing preparation for game..."
  table = Table.create({:game => self, :cards_count => 0})
  deck = Deck.create({:game => self})
  deck.init_cards
  6.times do
   self.players[0].add_card (deck.get_one)
   self.players[1].add_card (deck.get_one)
  end
 end

 def do_get_card_from_player _card, _player_id
  self.table.add_card(_card, _player_id)
 end

 def self.search(search)
  if search
   find(:all, :conditions => ['title LIKE ?', "%#{search}%"])
  else
   find(:all)
  end
 end
end