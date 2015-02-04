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
        table = Table.create({:game => self, :cards_count => NUMBER_ZERO,
                              :defender_cursor => NUMBER_ONE,
                              :attacker_cursor => NUMBER_ZERO})
        deck = Deck.create({:game => self})

        deck.init_cards

        set_attacker

        if mover == players[NUMBER_ZERO]
          first_player_move
        elsif mover == players[NUMBER_ONE]
          second_player_move
        end
      end
    end

    state :move_of_first_player, :move_of_second_player do
      def get_card_from_player(_card, _player, _attacker)
        players_get_card(_card, _player, _attacker) do
          if move_of_first_player?
            second_player_move
            self.mover = players[NUMBER_ONE]
          else
            first_player_move
            self.mover = players[NUMBER_ZERO]
          end
        end
      end

      def end_turn _player
        if mover == _player
          if(_player == attacker && table.cards_count > NUMBER_ZERO) #END from attacker
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
          if(players[NUMBER_ZERO] == mover)
            breaker = players[NUMBER_ONE]
          else
            breaker = players[NUMBER_ZERO]
          end
          do_break_turn breaker
        end
        if mover == players[NUMBER_ZERO]
          first_player_move
        elsif mover == players[NUMBER_ONE]
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

    first_min = find_smallest_trump players[NUMBER_ZERO]
    second_min = find_smallest_trump players[NUMBER_ONE]

    if(!first_min && !second_min)
      deck.shuffle_deck
      set_attacker
    else
      init_actors first_min, second_min
    end
  end

  def init_actors first, second
    if (!first)
      self.attacker, self.defender = players[NUMBER_ONE], players[NUMBER_ZERO]
      self.mover = players[NUMBER_ONE]
    elsif (!second)
      self.attacker, self.defender = players[NUMBER_ZERO], players[NUMBER_ONE]
      self.mover = players[NUMBER_ZERO]
    elsif first.rang < second.rang
      self.attacker, self.defender = players[NUMBER_ZERO], players[NUMBER_ONE]
      self.mover = players[NUMBER_ZERO]
    else
      self.attacker, self.defender = players[NUMBER_ONE], players[NUMBER_ZERO]
      self.mover = players[NUMBER_ONE]
    end
  end

  def init_players_cards
    NUMBER_SIX.times do
      players[NUMBER_ZERO].add_card (deck.get_one)
      players[NUMBER_ONE].add_card (deck.get_one)
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
    (NUMBER_SIX-players[NUMBER_ZERO].cards_count).times do
      if (deck.cursor < NUMBER_36)
        players[NUMBER_ZERO].add_card deck.get_one
      end
    end

    (NUMBER_SIX-players[NUMBER_ONE].cards_count).times do
      if (deck.cursor < NUMBER_36)
        players[NUMBER_ONE].add_card deck.get_one
      end
    end
  end

  def game_ended?
    game_end = FALSE
    if (deck.cursor == NUMBER_36 && (players[NUMBER_ZERO].cards_count == NUMBER_ZERO || players[NUMBER_ONE].cards_count == NUMBER_ZERO))
      game_end = TRUE
    end
    game_end
  end

  private

  def players_get_card (_card, _player, _attacker, &block)

    if mover == _player
      if players[NUMBER_ZERO] == _player
        current_player = players[NUMBER_ZERO]
      else
        current_player = players[NUMBER_ONE]
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
