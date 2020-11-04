require 'rails_helper'

RSpec.describe SessionsHelper do
  it 'should return the current_session', :authenticated do
    expect(helper.current_session).to be_a(OauthSession)
    expect(helper.current_session.access_token).to eq '1d355f021dce10e4410f2e5945a98fca1a30234615a00784340dcefd322d96d5'
  end
end