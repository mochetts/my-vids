class VideosPresenter < BasePresenter
  include Enumerable
  extend Forwardable

  def_delegators :@videos, :each, :<<, :any?
  attr_reader :videos, :page, :per_page

  def initialize(page: 1, per_page: 10)
    @videos = Video.all(page: page, per_page: per_page, sort: :created_at).map(&VideoDecorator)
    @page = page.to_i
    @per_page = per_page.to_i
  end

  def next_link
    has_next_page? ? link_to('Next >>', videos_path(page: next_page, per_page: per_page), class: pagination_links_class) : ''
  end

  def prev_link
    has_prev_page? ? link_to('<< Prev', videos_path(page: prev_page, per_page: per_page), class: pagination_links_class) : ''
  end

  def cache_key
    ['videos', current_session.cache_key, page, per_page].join('/')
  end

private

  def has_prev_page?
    page > 1
  end

  def has_next_page?
    videos.count == per_page
  end

  def prev_page
     page - 1
  end

  def next_page
    page + 1
  end

  def pagination_links_class
    'bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-r'
  end

end