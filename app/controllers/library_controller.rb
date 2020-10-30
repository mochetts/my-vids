class LibraryController < ApplicationController

  # GET /library
  def index
    @library = LibraryPresenter.new(**page_params)
  end

private

  def page_params
    params.permit(:page, :per_page).to_h.symbolize_keys
  end

end
