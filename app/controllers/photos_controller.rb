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

  private

  def require_login
    return if logged_in?

    redirect_to root_path, alert: "ログインが必要です"
  end

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
