module GamesHelper

  def make_suite cardSuite
    case cardSuite
      when 'diamonds'
        raw("<span class='redSuite'>&diams;</span>")
      when 'spades'
        raw("<span class='blackSuite'>&spades;</span>")
      when 'hearts'
        raw("<span class='redSuite'>&hearts;</span>")
      else
        raw("<span class='blackSuite'>&clubs;</span>")
    end
  end

  def make_rank card
  	if (card.suite == 'diamonds') || (card.suite == 'hearts')
      case card.rang
        when 0
          raw("<span class='redSuite'>6</span>")
        when 1
          raw("<span class='redSuite'>7</span>")
        when 2
          raw("<span class='redSuite'>8</span>")
        when 3
          raw("<span class='redSuite'>9</span>")
        when 4
          raw("<span class='redSuite'>10</span>")
        when 5
          raw("<span class='redSuite'>J</span>")
        when 6
          raw("<span class='redSuite'>Q</span>")
        when 7
          raw("<span class='redSuite'>K</span>")
        else
          raw("<span class='redSuite'>A</span>")
      end
    elsif (card.suite == 'spades') || (card.suite == 'clubs')
    	case card.rang
        when 0
          raw("<span class='blackSuite'>6</span>")
        when 1
          raw("<span class='blackSuite'>7</span>")
        when 2
          raw("<span class='blackSuite'>8</span>")
        when 3
          raw("<span class='blackSuite'>9</span>")
        when 4
          raw("<span class='blackSuite'>10</span>")
        when 5
          raw("<span class='blackSuite'>J</span>")
        when 6
          raw("<span class='blackSuite'>Q</span>")
        when 7
          raw("<span class='blackSuite'>K</span>")
        else
          raw("<span class='blackSuite'>A</span>")
      end
    end
  end

end