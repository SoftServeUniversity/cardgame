class Game < ActiveRecord::Base
  serialize :winner, Player
  serialize :loser, Player
  serialize :attacker, Player
  serialize :defender, Player
  serialize :mover, Player

  has_many :players, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_one :table, dependent: :destroy

  state_machine :state, :initial => :new_game do

    event :init_first_player do
      transition :new_game => :expactation_second_player
    end

    event :init_second_player do
      transition :expactation_second_player => :game_prepare
    end

    event :first_player_move do
      transition [:game_prepare, :move_of_second_player, :break_turn] => :move_of_first_player
    end

    event :second_player_move do
      transition [:game_prepare, :move_of_first_player, :break_turn] => :move_of_second_player
    end

    event :set_break_turn do
      transition [:move_of_first_player, :move_of_second_player] => :break_turn
    end


    state :new_game do
      def do_init_first_player _user
        puts "Doing init first player..."
        player = Player.create({:game => self, :user => _user})
        self.init_first_player
      end
    end

    state :expactation_second_player do
      def do_init_second_player _user
        puts "Doing init second player..."
        player = Player.create({:game => self, :user => _user})
        self.init_second_player
      end
    end

    state :game_prepare do
      def do_preparation_for_game
        puts "Doing preparation for game..."
        table = Table.create({:game => self, :cards_count => 0, :defender_cursor => 1, :attacker_cursor => 0})
        deck = Deck.create({:game => self})

        deck.init_cards

        set_attacker

        if self.mover == self.players[0]
          self.first_player_move
        elsif self.mover == self.players[1]
          self.second_player_move
        end
      end
    end

    state :move_of_first_player, :move_of_second_player do
      def get_card_from_player _card, _player, _attacker
        puts "==============================_player"
        puts _player
        if self.mover == _player

          if self.players[0] == _player
            current_player = self.players[0]
          else
            current_player = self.players[1]
          end

          if self.do_get_card_from_player _card, _player, _attacker
            current_player.delete_card _card

            if self.move_of_first_player?
              self.second_player_move
              self.mover = self.players[1]
            else
              self.first_player_move
              self.mover = self.players[0]
            end
          end
        else
          puts "Access denied"
        end
      end

      def end_turn _player
        puts "////////////////////END OF TURN in state"
        if self.mover == _player
          if(_player == self.attacker && self.table.cards_count > 0) #END from attacker
            puts "////////////////////ATTACKER END OF TURN in state"
            if self.move_of_first_player?
              self.second_player_move
            else
              self.first_player_move
            end
            self.do_end_turn
          elsif (_player == self.defender) #END from defender
            puts "////////////////////DEFENDER END OF TURN in state"
            self.set_break_turn
            self.mover = self.attacker
            puts "//////////////////////////////////////////////////////BreakTurn"
            puts self.state
          end
        end
      end
    end

    state :break_turn do
      def get_card_from_player _card, _player, _attacker
        if self.mover == _player

          if self.players[0] == _player
            current_player = self.players[0]
          else
            current_player = self.players[1]
          end

          if self.do_get_card_from_player _card, _player, _attacker
            current_player.delete_card _card
          end
        else
          puts "Access denied"
        end
      end

      def end_turn _player
        if self.mover == _player
          if(self.players[0] == self.mover)
            player = 1
          else
            player = 0
          end
          self.do_break_turn player
        end

        if self.mover == self.players[0]
          self.first_player_move
        elsif self.mover == self.players[1]
          self.second_player_move
        end
      end
    end
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
      if card
        self.players[breaker].add_card card
      end
    end
    self.table.clear

    init_new_turn
  end

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
