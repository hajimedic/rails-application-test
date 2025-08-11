class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = current_user.photos.with_attached_image.order(created_at: :desc)
  end

  def new
    # 次のステップで実装
  end

  def create
    # 次のステップで実装
  end

  private

  def require_login
    return if logged_in?

    redirect_to root_path, alert: "ログインが必要です"
  end
end
