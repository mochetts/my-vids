require 'rails_helper'

RSpec.describe My::Base do
  it 'should call super when method is not defined' do
    expect { My::Videos.undefined_method }.to raise_error(NoMethodError)
  end
end