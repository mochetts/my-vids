class VideosController < AuthenticatedController
  before_action :set_video, only: [:show]

  skip_before_action :authenticate, :only => :show
  before_action      :authenticate, :only => :show, unless: -> { @video.free? }

  # GET /videos/1
  def show
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = VideoDecorator.new(Video.find(params[:id]))
  end

end
