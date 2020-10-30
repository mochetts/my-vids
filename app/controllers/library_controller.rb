class LibraryController < ApplicationController

  # GET /library
  def index
    session[:last_library_url] = request.url
    @library = LibraryPresenter.new(**page_params)
  end

private

  def page_params
    params.permit(:page, :per_page).to_h.symbolize_keys
  end

end
