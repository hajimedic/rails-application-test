require "net/http"
require "uri"
require "json"

class OauthController < ApplicationController
  before_action :require_login

  def callback
    code = params[:code].to_s
    unless code.present?
      return redirect_to photos_path, alert: "認可コードが取得できませんでした"
    end

    token_endpoint = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/token"

    begin
      uri = URI.parse(token_endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 5
      http.read_timeout = 10

      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/x-www-form-urlencoded"
      req["Accept"] = "application/json"

      req.set_form_data(
        grant_type: "authorization_code",
        code: code,
        client_id: ENV["client_id"].to_s,
        client_secret: ENV["client_secret"].to_s,
        redirect_uri: "http://localhost:3000/oauth/callback"
      )

      res = http.request(req)
      if res.is_a?(Net::HTTPSuccess)
        body = JSON.parse(res.body) rescue {}
        access_token = body["access_token"].to_s
        if access_token.present?
          session[:oauth_access_token] = access_token
          redirect_to photos_path, notice: "OAuth アクセストークンを取得しました"
        else
          Rails.logger.error("OAuth token response missing access_token: #{res.body}")
          redirect_to photos_path, alert: "アクセストークンがレスポンスに含まれていません"
        end
      else
        Rails.logger.error("OAuth token request failed: status=#{res.code} body=#{res.body}")
        redirect_to photos_path, alert: "トークン取得に失敗しました (#{res.code})"
      end
    rescue => e
      Rails.logger.error("OAuth token request error: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}")
      redirect_to photos_path, alert: "トークン取得時にエラーが発生しました"
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "ログインが必要です" unless logged_in?
  end
end
