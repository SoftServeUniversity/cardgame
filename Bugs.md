= Bug CD001

Summary: When no second user the server losts it's session.

1. Create New Game
2. Open Console

Actual Result:

SERVER LOG

Processing by GamesController#show as JSON
  Parameters: {"id"=>"1"}
  Game Load (0.1ms)  SELECT  "games".* FROM "games"  WHERE "games"."id" = ? LIMIT 1  [["id", 1]]
Completed 500 Internal Server Error in 4ms

NoMethodError (undefined method `id' for nil:NilClass):
  app/controllers/games_controller.rb:158:in `resp_to_json'
  app/controllers/games_controller.rb:12:in `show'


BROWERS: Server 500 Error


=========================================================


= Bug CD002

Summary: Session of the primary user is lost when second user joins the game.



=========================================================

= Bug CD003

Summary: When player looses session ( gets log out ) he still can see the desk.



=========================================================

= Bug CD004

Summary: 


