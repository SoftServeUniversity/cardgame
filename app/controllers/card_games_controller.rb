class CardGamesController < ApplicationController
  before_action :set_card_game, only: [:show, :edit, :update, :destroy]

  # GET /card_games
  # GET /card_games.json
  def index
    @card_games = CardGame.all
  end

  # GET /card_games/1
  # GET /card_games/1.json
  def show
  end

  # GET /card_games/new
  def new
    @card_game = CardGame.new
  end

  # GET /card_games/1/edit
  def edit
  end

  # POST /card_games
  # POST /card_games.json
  def create
    @card_game = CardGame.new(card_game_params)

    respond_to do |format|
      if @card_game.save
        format.html { redirect_to @card_game, notice: 'Card game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card_game }
      else
        format.html { render action: 'new' }
        format.json { render json: @card_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /card_games/1
  # PATCH/PUT /card_games/1.json
  def update
    respond_to do |format|
      if @card_game.update(card_game_params)
        format.html { redirect_to @card_game, notice: 'Card game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @card_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_games/1
  # DELETE /card_games/1.json
  def destroy
    @card_game.destroy
    respond_to do |format|
      format.html { redirect_to card_games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card_game
      @card_game = CardGame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_game_params
      params.require(:card_game).permit(:title, :notes)
    end
end
