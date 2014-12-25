require 'rails_helper'

RSpec.describe "Games", :type => :request do
  describe "GET /games" do
    it "displays games" do
      Game.create!(:name => "game", :description => "for pro players")
      get games_path
      expect(response).to render_template("index")
      response.body.should include("Games")
      response.body.should include("for pro players")
    end
  end

  # describe "POST /games" do
  #   it "create game" do
  #     controller.stub!(:authenticate).and_return(true)
  #     post_via_redirect games_path, :game => {:name => "mov", :description => "lan"}
  #     response.body.should include("mov")
  #     response.body.should include("lan")
  #   end
  # end
end
