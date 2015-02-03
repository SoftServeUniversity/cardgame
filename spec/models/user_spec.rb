require 'rails_helper'
require 'pry'

describe User do

  let(:user){ build(:user) }
  subject(:associate){ User.reflect_on_association(:player)}

  it "should have assosiation has_one player" do
    expect(associate.macro).to eq(:has_one)
  end

  it "shouldn't have assosiation belongs_to Game" do
    expect(associate.macro).to_not  eq(:belongs_to)
  end

  describe "#after_initialize :init" do
    context "calling User.new triggers method init" do

      it {expect(user.games_count).to eq(NUMBER_ZERO)}
      it {expect(user.lose_count).to eq(NUMBER_ZERO)}
      it {expect(user.win_count).to eq(NUMBER_ZERO)}
      it {expect(user.view_theme).to eq(THEME_CLASSIC)}
    end
  end

  describe "#self.find_for_database_authentication" do
    it "should invoke #dup and #delete 
        on given param and find user with given name" do
      setup_user_for_database_auth(NAME_SAMPLE)

      expect(User.find_for_database_authentication(@warden_condition)).to eq(@user)
    end

    it "should invoke #dup and #delete 
        on given param and find user with given email" do
      setup_user_for_database_auth(NIL, EMAIL_SAMPLE)

      expect(User.find_for_database_authentication(@warden_condition)).to eq(@user)
    end

    it "should not find any user if name doesn't match" do
      setup_user_for_database_auth(WRONG_NAME_SAMPLE)
      
      expect(User.find_for_database_authentication(@warden_condition)).to be_nil
    end
  end

end
