
def video_fixture(attrs = {})
  {
    _id: "56a7b83069702d2f8306d9b7",
    title: "Teacher Trial with Ronda Rousey - SNL",
    description: "Gavin Daly (Pete Davidson) testifies about having an inappropriate sexual relationship with his teachers (Ronda Rousey, Cecily Strong) – happily.\n\nSubscribe to the SNL channel for more clips: http://goo.gl/24RRTv\n\nDownload the SNL App for free: http://www.nbc.com/saturday-night-live/app\n\nFor more SNL 40th Anniversary Special: http://goo.gl/gLyPTc\n\nGet more SNL on Hulu Plus: http://www.hulu.com/saturday-night-live\n\nGet more SNL: http://www.nbc.com/saturday-night-live\nFull Episodes: http://www.nbc.com/saturday-night-live/video\n\nLike SNL: https://www.facebook.com/snl\nFollow SNL: https://twitter.com/nbcsnl\nSNL Tumblr: http://nbcsnl.tumblr.com/\nSNL Instagram: http://instagram.com/nbcsnl \nSNL Google+: https://plus.google.com/+SaturdayNightLive/ \nSNL Pinterest: http://www.pinterest.com/nbcsnl/",
    created_at: "2016-01-26T13:17:20.662-05:00",
    published_at: "2016-01-24T04:03:19.000-05:00",
    thumbnails: [
      {
        aspect_ratio: 1.78,
        height: 240,
        name: nil,
        url: "https://image.zype.com/56a7b4a369702d1927000000/56a7b83069702d2f8306d9b7/custom_thumbnail/240.jpg?1507608803",
        width: 426
      },
      {
        aspect_ratio: 1.78,
        height: 480,
        name: nil,
        url: "https://image.zype.com/56a7b4a369702d1927000000/56a7b83069702d2f8306d9b7/custom_thumbnail/480.jpg?1507608803",
        width: 854
      },
      {
        aspect_ratio: 1.78,
        height: 720,
        name: nil,
        url: "https://image.zype.com/56a7b4a369702d1927000000/56a7b83069702d2f8306d9b7/custom_thumbnail/720.jpg?1507608803",
        width: 1280
      },
      {
        aspect_ratio: 1.78,
        height: 1080,
        name: nil,
        url: "https://image.zype.com/56a7b4a369702d1927000000/56a7b83069702d2f8306d9b7/custom_thumbnail/1080.jpg?1507608803",
        width: 1920
      }
    ],
    short_description: "Gavin Daly (Pete Davidson) testifies about having an inappropriate sexual relationship with his teachers (Ronda Rousey, Cecily Strong) – happily.\n\nSubscribe to the SNL channel for more clips: http://goo.gl/24RRTv\n\nDownload the SNL App for free: ht...",
    subscription_required: true
  }.merge(attrs)
end

def videos_fixture(count = 1)
  (1..count).to_a.map { |id|
    video_fixture({ _id: id })
  }
end

def logged_in_session_fixture(attrs = {})
  token_time = Time.current
  session_fixture(
    {
      session_id: "36b3a24529e55847c082e8fef60a42b5",
      errors: [],
      last_library_url: "http://localhost:3000/library",
      _csrf_token: "2pj6iLLv+EjxPye71W/VIV/SDAGpQ7XSohuizfnq8hI=",
      access_token: "1d355f021dce10e4410f2e5945a98fca1a30234615a00784340dcefd322d96d5",
      token_type: "Bearer",
      expires_in: 604800,
      refresh_token: "9a2d10f4258720b23791258d00da839ee927f85be1ffbfd5d9e3fd36e73141bf",
      scope: "consumer",
      created_at: token_time.to_i,
      expires_at: (token_time + Settings.session.expiration.days).as_json,
      username: "test@test.com",
      password: "password"
    }.merge(attrs)
  )
end

def session_fixture(attrs = {})
  {}.merge(attrs)
end