module GamesHelper

  CARD_SUITES = {
    'diamonds' => '&diams;',
    'spades' => '&spades;',
    'hearts' => '&hearts;',
    'clubs' => '&clubs;',
  }
  
  SUITES_COLORS = {
    'diamonds' => 'red',
    'spades' => 'black',
    'hearts' => 'red',
    'clubs' => 'black',
  }

  CARD_RANKS = {
    0 => '6',
    1 => '7',
    2 => '8',
    3 => '9',
    4 => '10',
    5 => 'J',
    6 => 'Q',
    7 => 'K',
    8 => 'A',
  }



  def make_suite cardSuite
    raw("<span class='#{SUITES_COLORS[cardSuite]}Suite'>#{CARD_SUITES[cardSuite]}</span>")
  end

  def make_rank card
    raw("<span class='#{SUITES_COLORS[card.suite]}Suite'>#{CARD_RANKS[card.rang]}</span>")   
  end


  def define_table_style
    if current_user
      if current_user.view_theme == nil
        "tableClassic"
      elsif current_user.view_theme
        "table#{current_user.view_theme.to_s}"
      else
        "tableClassic"
      end
    else
      "tableClassic"
    end
  end


  def player_check
    (current_user.player == @game.players[0]) || (current_user.player == @game.players[1])
  end  

  def mover_check
    ( @game.mover.user && @game.attacker.user && @game.defender.user )    
  end


  def game_turn_message
    your_attack = "Your attack!"
    your_defence = "Your defence!"
    opponent_attack = "Opponent`s attack!"
    opponent_defence = "Opponent`s defence!"
    waiting = "Waiting of an Opponent!"

    if mover_check
      if current_user.id == @game.mover.user.id
        if current_user.id == @game.attacker.user.id
          raw("<span> #{your_attack} </span>")
        elsif current_user.id == @game.defender.user.id
          raw("<span> #{your_defence} </span>")
        end
      else
        if current_user.id == @game.attacker.user.id
          raw("<span> #{opponent_defence} </span>")
        elsif current_user.id == @game.defender.user.id
          raw("<span> #{opponent_attack} </span>")
        end
      end
    else
      raw("<span> #{waiting} </span>")
    end
  end

  def split_array ( array )
    hit_cards = []
    array.each_index do |index|
      if (index) % 2 == 0
        hit_cards << array[index]
      end
    end
    defence_cards = array - hit_cards
    table_cards = [ hit_cards, defence_cards ]
    return table_cards
  end


end