class VideoIndexDecorator < VideoDecorator

  delegate(
    :short_description,
    to: :video
  )

  def thumbnail
    video.thumbnails.find { |t| t.symbolize_keys[:height] == 480 } || video.thumbnails.first
  end

end