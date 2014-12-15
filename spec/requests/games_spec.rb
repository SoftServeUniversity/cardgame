#require 'rails_helper'

# RSpec.describe "Games", :type => :request do
#   describe "GET /games" do
#     it "displays games" do
#       Game.create!(:name => "azaza", :description => "bla_test")
#       get games_path
#       expect(response).to render_template("index")
#       response.body.should include("Games")
#     end
#   end

#   describe "POST /games" do
#     it "create game" do
#       post_via_redirect games_path, :game => {:name => "mov", :description => "lan"}
#       response.body.should include("mov")
#       response.body.should include("lan")
#     end
#   end
# end
