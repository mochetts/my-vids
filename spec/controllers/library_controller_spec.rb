require 'rails_helper'

RSpec.describe LibraryController do
  let(:page) { '1' }
  let(:per_page) { '5' }

  before do
    allow(My::Videos).to receive(:all).and_return(videos_fixture(per_page.to_i))
  end

  describe 'GET index' do
    it 'should show the video when authenticated', :authenticated do
      expect(LibraryPresenter).to receive(:new).with(page: page, per_page: per_page)
      get :index, params: { page: page, per_page: per_page }
      expect(session[:last_library_url]).to include("page=#{page}&per_page=#{per_page}")
      expect(response.status).to eq 200
    end
  end
end