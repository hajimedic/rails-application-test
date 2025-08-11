class PhotosController < ApplicationController
  before_action :require_login

  def index
    # TODO: 次のステップで写真一覧を実装
    render plain: "写真一覧（仮）"
  end

  private

  def require_login
    return if logged_in?

    redirect_to root_path, alert: "ログインが必要です"
  end
end
