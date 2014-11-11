require 'test_helper'

class CardGamesControllerTest < ActionController::TestCase
  setup do
    @card_game = card_games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:card_games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card_game" do
    assert_difference('CardGame.count') do
      post :create, card_game: { notes: @card_game.notes, title: @card_game.title }
    end

    assert_redirected_to card_game_path(assigns(:card_game))
  end

  test "should show card_game" do
    get :show, id: @card_game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @card_game
    assert_response :success
  end

  test "should update card_game" do
    patch :update, id: @card_game, card_game: { notes: @card_game.notes, title: @card_game.title }
    assert_redirected_to card_game_path(assigns(:card_game))
  end

  test "should destroy card_game" do
    assert_difference('CardGame.count', -1) do
      delete :destroy, id: @card_game
    end

    assert_redirected_to card_games_path
  end
end
