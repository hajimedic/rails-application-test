class SessionsController < ApplicationController
  layout false, only: [ :new ]

  def new
    # render login form
  end

  def create
    user_id = params[:user_id].to_s.strip
    password = params[:password].to_s

    errors = []
    errors << "ユーザーIDが未入力です" if user_id.blank?
    errors << "パスワードが未入力です" if password.blank?

    if errors.any?
      flash.now[:alert] = errors.join(" / ")
      return render :new, status: :unprocessable_entity
    end

    user = User.find_by(user_id: user_id)
    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to photos_path, notice: "ログインしました"
    else
      flash.now[:alert] = "ユーザーIDとパスワードが一致するユーザーが存在しません"
      render :new, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end
