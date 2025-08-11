module ApplicationHelper
  def oauth_authorize_url
    endpoint = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/authorize"
    client_id = ENV["client_id"].to_s

    params = {
      client_id: client_id,
      response_type: "code",
      redirect_uri: "http://localhost:3000/oauth/callback",
      scope: "write_tweet"
      # state は未使用
    }

    query = Rack::Utils.build_query(params)
    "#{endpoint}?#{query}"
  end
end
