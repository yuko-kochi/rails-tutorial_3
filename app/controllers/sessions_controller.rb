class SessionsController < ApplicationController
  def new
  end

  def create
    # downcaseメソッドを使って、有効なメールアドレスが入力されたときに確実にマッチするようにする
    user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    # authenticateメソッドパスワードを引数としてユーザーの認証を行うことができる
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to user
    else
      # flash.nowのメッセージはその後リクエストが発生したときに消滅
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
