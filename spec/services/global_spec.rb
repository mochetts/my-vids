require 'rails_helper'

RSpec.describe Global do
  before do
    allow(ENV).to receive(:fetch).and_raise(KeyError)
  end

  it 'should raise exception' do
    expect { Global.get('SOME_KEY') }.to raise_error(KeyError)
  end
end