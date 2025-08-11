class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = current_user.photos.with_attached_image.order(created_at: :desc)
  end

  def new
    @photo = current_user.photos.new
  end

  def create
    @photo = current_user.photos.new(photo_params)
    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました"
    else
      flash.now[:alert] = @photo.errors.full_messages.join(" / ")
      render :new, status: :unprocessable_entity
    end
  end

  def tweet
    unless oauth_access_token.present?
      return redirect_to photos_path, alert: "OAuth 連携が未完了です"
    end

    photo = current_user.photos.find_by(id: params[:id])
    return redirect_to photos_path, alert: "写真が見つかりません" unless photo

    # 画像URLを生成（Active Storage の公開URLを使用）
    image_url = url_for(photo.image) if photo.image.attached?

    payload = {
      text: photo.title.to_s,
      url: image_url.to_s
    }

    endpoint = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/api/tweets"

    begin
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 5
      http.read_timeout = 10

      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{oauth_access_token}"
      req.body = payload.to_json

      res = http.request(req)
      if res.code.to_i == 201
        redirect_to photos_path, notice: "ツイートを投稿しました"
      else
        Rails.logger.error("Tweet API failed: status=#{res.code} body=#{res.body}")
        redirect_to photos_path, alert: "ツイートに失敗しました (#{res.code})"
      end
    rescue => e
      Rails.logger.error("Tweet API error: #{e.class}: #{e.message}")
      redirect_to photos_path, alert: "ツイート送信時にエラーが発生しました"
    end
  end

  private

  def require_login
    return if logged_in?

    redirect_to root_path, alert: "ログインが必要です"
  end

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
