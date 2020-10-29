class VideosController < AuthenticatedController
  before_action :set_video, only: [:show]

  skip_before_action :authenticate, :only => [:index, :show]
  before_action      :authenticate, :only => :show, unless: -> { @video.free? }

  # GET /videos
  def index
    @videos = VideosPresenter.new(**page_params)
  end

  # GET /videos/1
  def show
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = VideoDecorator.new(Video.find(params[:id]))
  end

  def page_params
    params.permit(:page, :per_page).to_h.symbolize_keys
  end

end
