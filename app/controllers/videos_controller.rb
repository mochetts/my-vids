class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = VideosPresenter.new(**page_params)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  def page_params
    params.permit(:page, :per_page).to_h.symbolize_keys
  end

end
