module UsersHelper
  def user_sign_in(user)
    session[:user_id] = user.id
  end

  # 現在サインイン中のユーザー情報を返す
  # if @current_userならnil
  # elseならすでにサインインしている
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  # present?存在するかしないか
  def user_signed_in?
    current_user.present?
  end

  # unless文　逆の意味
  # サインインしているかの確認メソッド？
  # 認証チェック　もう一度サインインする
  def authorize
    redirect_to sign_in_path unless user_signed_in?
  end

  # サインイン済みならトップページに遷移する
  # and return
  def redirect_to_top_if_signed_in
    redirect_to top_path if user_signed_in?
  end
end
