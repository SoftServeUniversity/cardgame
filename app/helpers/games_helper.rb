module GamesHelper

  def set_statistic
    if @game.players[1]
      @user1 = @game.players[0].user
      @user2 = @game.players[1].user

      @user1.games_count += 1
      @user2.games_count += 1

      if @game.winner

        if @user1 == @game.winner
          @user1.win_count += 1
          @user2.lose_count += 1
        else
          @user2.win_count += 1
          @user1.lose_count += 1
        end
      else
        if current_user == @user1
          @user2.win_count += 1
          @user1.lose_count += 1
        else
          @user1.win_count += 1
          @user2.lose_count += 1
        end
      end
      puts"()()()()()()()()"
      @user1.save
      @user2.save
      puts @user1.games_count
      puts @user2.games_count

      return @user1, @user2
    end
  end

  def check_game_end
    response = false
    if @game.game_ended?
      if @game.players[0].cards_count == 0
        @game.winner, @game.loser = @game.players[0], @game.players[1]
      else
        @game.winner, @game.loser = @game.players[1], @game.players[0]
      end
      @game.save
      end_game
      response = true
    end
    response
  end
end