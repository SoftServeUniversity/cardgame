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
        player = Player.create({:game => self, :user => _user})
        init_first_player
      end
    end

    state :expactation_second_player do
      def do_init_second_player _user
        player = Player.create({:game => self, :user => _user})
        init_second_player
      end
    end

    state :game_prepare do
      def do_preparation_for_game
        table = Table.create({:game => self, :cards_count => 0, :defender_cursor => ONE,
                              :attacker_cursor => ZERO})
        deck = Deck.create({:game => self})

        deck.init_cards

        set_attacker

        if mover == players[0]
          first_player_move
        elsif mover == players[1]
          second_player_move
        end
      end
    end

    state :move_of_first_player, :move_of_second_player do
      def get_card_from_player(_card, _player, _attacker)
        players_get_card(_card, _player, _attacker) do
          if move_of_first_player?
            second_player_move
            self.mover = players[1]
          else
            first_player_move
            self.mover = players[0]
          end
        end
      end

      def end_turn _player
        if mover == _player
          if(_player == attacker && table.cards_count > 0) #END from attacker
            if move_of_first_player?
              second_player_move
            else
              first_player_move
            end
            do_end_turn
          elsif (_player == defender) #END from defender
            set_break_turn
            self.mover = self.attacker
          end
        end
      end
    end

    state :break_turn do
      def get_card_from_player(_card, _player, _attacker)
        players_get_card(_card, _player, _attacker)
      end

      def end_turn _player
        if mover == _player
          if(players[0] == mover)
            breaker = players[1]
          else
            breaker = players[0]
          end
          do_break_turn breaker
        end

        if mover == players[0]
          first_player_move
        elsif mover == players[1]
          second_player_move
        end
      end
    end
  end

  def do_get_card_from_player _card, _player, _attacker
    table.add_card _card, _player, _attacker
  end

  def do_end_turn
    table.clear

    self.attacker, self.defender = self.defender, self.attacker
    self.mover = self.attacker
    init_new_turn
  end

  def do_break_turn breaker
    table.table_cards.each do |card|
      if card
        breaker.add_card card
      end
    end
    table.clear

    init_new_turn
  end

  def set_attacker
    init_players_cards

    first_min = find_smallest_trump players[0]
    second_min = find_smallest_trump players[1]

    if(!first_min && !second_min)
      deck.shuffle_deck
      set_attacker
    else
      init_actors first_min, second_min
    end
  end

  def init_actors first, second
    if (!first)
      self.attacker, self.defender = players[1], players[0]
      self.mover = players[1]
    elsif (!second)
      self.attacker, self.defender = players[0], players[1]
      self.mover = players[0]
    elsif first.rang < second.rang
      self.attacker, self.defender = players[0], players[1]
      self.mover = players[0]
    else
      self.attacker, self.defender = players[1], players[0]
      self.mover = players[1]
    end
  end

  def init_players_cards
    6.times do
      players[0].add_card (deck.get_one)
      players[1].add_card (deck.get_one)
    end
  end

  def find_smallest_trump player
    min = nil
    player.player_cards.each do |card|
      if card.suite.to_s == deck.trump.to_s
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
    (STARTING_QUANTITY-players[0].cards_count).times do
      if (deck.cursor < ALL_DECK_CARDS)
        players[0].add_card deck.get_one
      end
    end

    (STARTING_QUANTITY-players[1].cards_count).times do
      if (deck.cursor < ALL_DECK_CARDS)
        players[1].add_card deck.get_one
      end
    end
  end

  def game_ended?
    game_end = false
    if (deck.cursor == ALL_DECK_CARDS && (players[0].cards_count == 0 || players[1].cards_count == 0))
      game_end = true
    end
    game_end
  end

  private

  def players_get_card (_card, _player, _attacker, &block)

    if mover == _player
      if players[0] == _player
        current_player = players[0]
      else
        current_player = players[1]
      end
      if do_get_card_from_player _card, _player, _attacker
        current_player.delete_card _card
      end
      if block_given?
        yield
      end

    else
      puts "Access denied"
    end
  end

end
