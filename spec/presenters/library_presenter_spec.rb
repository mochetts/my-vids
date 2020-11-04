require 'rails_helper'

RSpec.describe LibraryPresenter do
  let(:video) { Video.new(video_fixture) }
  let(:page) { 2 }
  let(:per_page) { 5 }
  let(:page_count) { per_page }
  let(:presenter) { LibraryPresenter.new(page: page, per_page: per_page) }

  before(:each) do
    # Stub API call
    allow(My::Videos).to receive(:all) do |args|
      expect(args[:params]).to eq({ page: page, per_page: per_page, sort: :created_at, order: :desc })
      videos_fixture(page_count) # Return page instances
    end
  end

  context 'videos' do
    it 'should return a list of decorated videos' do
      expect(presenter.videos.all? { |vid| vid.is_a?(VideoDecorator) }).to eq true
      expect(presenter.videos.map(&:video).map(&:attributes)).to match_array videos_fixture(page_count).map(&Video).map(&:attributes)
    end
  end

  context 'next_link' do
    it 'should show a next link' do
      expect(presenter.next_link).to eq "<a class=\"bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-r\" href=\"/library?page=3&amp;per_page=5\">Older</a>"
    end

    context 'should not show a next link' do
      let(:page_count) { 3 }

      it '' do
        expect(presenter.next_link).to eq ''
      end
    end
  end

  context 'prev_link' do
    it 'should show a prev link' do
      expect(presenter.prev_link).to eq "<a class=\"bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-r\" href=\"/library?page=1&amp;per_page=5\">Newer</a>"
    end

    context 'should not show a prev link' do
      let(:page) { 1 }

      it '' do
        expect(presenter.prev_link).to eq ''
      end
    end
  end

  context 'cache_key' do
    it 'authenticated', :authenticated do
      expect(presenter.cache_key).to eq ['library', current_session.username, page, per_page].join('/')
    end

    it 'not authenticated' do
      expect(presenter.cache_key).to eq ['library', 'public', page, per_page].join('/')
    end
  end
end