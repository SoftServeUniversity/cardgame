class Game < ActiveRecord::Base
  serialize :winner, Player
  serialize :loser, Player
  serialize :attacker, Player
  serialize :defender, Player
  serialize :mover, Player

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
    when 'EndOfGame'
      @state = EndOfGame.new self
    when 'BreakTurn'
      @state = BreakTurn.new self
    end
    @state
  end

  def set_game_state _state
    @state = _state
    self.state_name = _state.class.name
  end

  def init
    @state = NewGame.new(self)
    self.state_name = @state.class.name
  end

  def init_player _user
    @state.init_player _user
  end

  def prepare_game_to_start
    @state.prepare_game_to_start
  end

  def get_card_from_player _card, _player, _attacker
    @state.get_card_from_player _card, _player, _attacker
  end

  def end_turn _player
    puts "///////////////////////////////////////////END TURN GAME"
    @state.end_turn _player
  end

  def show_results
    @state.show_results
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
    table = Table.create({:game => self, :cards_count => 0, :defender_cursor => 1, :attacker_cursor => 0})
    deck = Deck.create({:game => self})

    deck.init_cards

    set_attacker
  end

  def do_get_card_from_player _card, _player, _attacker
    puts "Doing getting card from player"
    self.table.add_card _card, _player, _attacker
  end

  def do_end_turn
    self.table.clear

    self.attacker, self.defender = self.defender, self.attacker
    self.mover = self.attacker
    init_new_turn
  end

  def do_break_turn breaker
    puts "////////////////Doing breaking turn"
    self.table.table_cards.each do |card|
      if(card)
        puts card.suite
        puts card.rang
        self.players[breaker].add_card card
      end
    end
    self.table.clear

    init_new_turn
  end
#
  def set_attacker
    init_players_cards

    first_min = find_smallest_trump self.players[0]
    second_min = find_smallest_trump self.players[1]
    puts "---------------------------------------------------"

    if(!first_min && !second_min)
      puts "-------------------------------No trump"
      self.deck.shuffle_deck
      set_attacker
    else
      if (!first_min)
        puts "----------------- first_min = nil"
        self.attacker = self.players[1]
        self.defender = self.players[0]
        self.mover = self.players[1]
      elsif (!second_min)
        puts "----------------- second_min = nil"
        self.attacker = self.players[0]
        self.defender = self.players[1]
        self.mover = self.players[0]
      elsif first_min.rang < second_min.rang
        puts "----------------- first_min <  second_min"
        self.attacker = self.players[0]
        self.defender = self.players[1]
        self.mover = self.players[0]
      else
        puts "----------------- first_min >  second_min"
        self.attacker = self.players[1]
        self.defender = self.players[0]
        self.mover = self.players[1]
      end
    end
  end

  def init_players_cards
    6.times do
      self.players[0].add_card (deck.get_one)
      self.players[1].add_card (deck.get_one)
    end
  end

  def find_smallest_trump player
    min = nil
    player.player_cards.each do |card|
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
    (6-self.players[0].cards_count).times do
      puts"//////////////////////////// get one card to player 0"
      if (self.deck.cursor < 36)
        self.players[0].add_card self.deck.get_one
      end
    end

    (6-self.players[1].cards_count).times do
      puts"//////////////////////////// get one card to player 1"
      if (self.deck.cursor < 36)
        self.players[1].add_card self.deck.get_one
      end
    end
  end

  def game_ended?
    game_end = false
    if (self.deck.cursor == 36 && (self.players[0].cards_count == 0 || self.players[1].cards_count == 0))
      game_end = true
    end
    game_end
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
