require "new_game"
require "deck"
require "card"

class Game < ActiveRecord::Base

  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_one :table, dependent: :destroy

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
    @state.get_card_from_player _card, _player_id
  end

  def end_turn _player_id
    puts "///////////////////////////////////////////END TURN GAME"
    @state.end_turn _player_id
  end

  def do_init_first_player _user
    puts "Doing init first player..."
    player = Player.create({:game => self, :user => _user})
  end

  def do_init_second_player _user
    puts "Doing init second player..."
    player = Player.create({:game => self, :user => _user})
  end

  def do_preparation_for_game
    puts "Doing preparation for game..."
    table = Table.create({:game => self, :cards_count => 0})
    deck = Deck.create({:game => self})

    deck.init_cards

    set_attacker
  end

  def do_get_card_from_player _card, _player_id
    puts "Doing getting card from player"
    self.table.add_card(_card, _player_id)
  end

  def do_end_turn
    puts "//////////////Doing end of turn"
    self.table.clear

    puts "///////////////////////////////////attacker"
    puts self.attacker
    puts "///////////////////////////////////defender"
    puts self.defender
    puts "///////////////////////////////////mover"
    puts self.mover

    att = self.attacker
    self.mover = self.defender
    puts "///////////////////////////////////mover"
    puts self.mover
    self.attacker = self.defender
    self.defender = att

    init_new_turn
  end

  def do_break_turn _breaker
    puts "////////////////Doing breaking turn"
    for i in 0...self.table.table_cards.length
      puts "i = " + i.to_s
      puts self.table.table_cards[i].suite
      puts self.table.table_cards[i].rang
      self.players[_breaker].add_card self.table.table_cards[i]
    end
    self.table.clear

    puts "///////////////////////////////////mover"
    puts self.mover
    self.mover = attacker

    puts "///////////////////////////////////mover"
    puts self.mover

    init_new_turn
  end

  def set_attacker
    init_players_cards

    first_min = find_smallest_trump self.players[0]
    second_min = find_smallest_trump self.players[1]
    puts "---------------------------------------------------"

    if first_min
      puts first_min.rang
    end
    if second_min
      puts second_min.rang
    end

    if(!first_min && !second_min)
      puts "-------------------------------No trump"
      self.deck.shuffle_deck
      set_attacker
    else
      if (!first_min)
        puts "----------------- first_min = nil"
        self.attacker = self.players[1].id
        self.defender = self.players[0].id
        self.mover = self.players[1].id
      elsif (!second_min)
        puts "----------------- second_min = nil"
        self.attacker = self.players[0].id
        self.defender = self.players[1].id
        self.mover = self.players[0].id
      elsif first_min.rang < second_min.rang
        puts "----------------- first_min <  second_min"
        self.attacker = self.players[0].id
        self.defender = self.players[1].id
        self.mover = self.players[0].id
      else
        puts "----------------- first_min >  second_min"
        self.attacker = self.players[1].id
        self.defender = self.players[0].id
        self.mover = self.players[1].id
      end
    end
  end

  def init_players_cards
    6.times do
      self.players[0].add_card (deck.get_one)
      self.players[1].add_card (deck.get_one)
    end
  end

  def find_smallest_trump _player
    min = nil
    _player.player_cards.each do |card|
      if card.suite.to_s == self.deck.trump.to_s
        if min
          if (card.rang < min.rang)
            min = card
          end
        else
          min = card
        end
      end
    end
    min
  end

  def init_new_turn
    for i in self.players[0].cards_count .. 6
      self.players[0].add_card self.deck.get_one
    end

    for i in self.players[1].cards_count .. 6
      self.players[1].add_card self.deck.get_one
    end
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
