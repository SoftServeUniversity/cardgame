module ModelHelpers

  def deck_card_init(num , rang, suite)
    @deck.deck_cards[num] = build(:card, suite: suite, rang: rang)
  end

  def setup_user_for_database_auth(name = nil, email = nil)
    if name
      @user = create(:user, username: "villy")
      @warden_condition = {login: name}
      @warden_condition.expects(:dup).returns({login: name})
      @warden_condition.expects(:delete).with(:login).returns(name)
    elsif email
      @user = create(:user, email: "villy@gmail.com")
      @warden_condition = {login: email}
      @warden_condition.expects(:dup).returns({login: email})
      @warden_condition.expects(:delete).with(:login).returns(email)
    end
  end
end

RSpec.configure do |config|
  config.include ModelHelpers, :type => :model
end
