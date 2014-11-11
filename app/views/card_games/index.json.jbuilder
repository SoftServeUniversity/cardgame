json.array!(@card_games) do |card_game|
  json.extract! card_game, :id, :title, :notes
  json.url card_game_url(card_game, format: :json)
end
