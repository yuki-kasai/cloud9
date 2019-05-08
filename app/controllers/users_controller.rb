class UsersController < ApplicationController
  # アクションメソッドの前にauthorizeメソッドを使い
  # except以外のページならサインインしていなければ
  # サインページに戻す
  before_action :authorize, except: %i[sign_up sign_up_process sign_in sign_in_process]

  before_action :redirect_to_top_if_signed_in, only: %i[sign_up sign_in]

  def top
    @posts = Post.all.order('id desc')
    if params[:word].present?
    # キーワード検索処理
      @posts = Post.where("caption like ?", "%#{params[:word]}%").order("id desc")
    else
    # 一覧表示処理
      @posts = Post.all.order("id desc").page(params[:page])
    end
    
    @recommends = User.where.not(id: current_user.id).where.not(id: current_user.follows.pluck(:follow_user_id)).limit(3)
 
  end
  

  # ユーザー登録ページ
  def sign_up
    @user = User.new
    render layout: 'application_not_login'
  end

  def sign_up_process
    # htmlの入力内容からフォームデータを受け取る
    # インスタンスメソッドのuser_paramsが新規登録者の情報
    # userクラスは暗号化とバリテーションチェックをする

    # バリデーションチェックする項目
    # name , email, password

    @user = User.new(user_params)

    # modelsのチェックした内容を
    # コントローラ側で操作する

    # 操作の仕方をコントローラ側で書く

    # 内容を保存成功したら
    # 保存した内容をDBに入れる
    # トップページに戻る

    if @user.save
      redirect_to action: 'top'
      # 保存に失敗したら
      # エラーを表示させて
      # 登録ページに戻す
    else
      flash[:danger] = 'ユーザー登録に失敗しました。'
      redirect_to action: 'sign_up'
    end
  end

  # サインインページ
  # rotesからコントローラーのsing_inアクションに遷移
  # User.newでインスタンス作成
  # @userでviewに値を渡す（メールアドレスとパスワード）
  def sign_in
    @user = User.new
    render layout: 'application_not_login'
  end

  # サインイン処理
  def sign_in_process
    # データ受取と暗号化
    # Userモデルのgenerate_passwordクラスメソッドの
    # user_paramsインスタンスメソッドのpasswordキーを代入（パスワードをmd5に変換）
    password_md5 = User.generate_password(user_params[:password])
    # DB検索
    # find_byメソッドでemailとpasswordのカラムからデータを取得
    user = User.find_by(email: user_params[:email], password: password_md5)

    if user
      # セッション処理
      user_sign_in(user)
      # トップ画面へ遷移する
      redirect_to(top_path) && return
    else
      flash[:danger] = 'サインインに失敗しました。'
    end

    # フォームのデータを受け取る
    user = User.new(user_params)
    if user.save
      # 登録が成功したらサインインしてトップページへ
      user_sign_in(user)
      redirect_to(top_path) && return
    end
  end

  # サインアウト
  # 再度同じidで入れないようにセッションを削除
  # idが空になる
  def user_sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  # サインアウト処理
  def sign_out
    # ユーザーセッションを破棄
    # サインアウトアクションを使う
    user_sign_out
    # サインインページへ遷移
    redirect_to(sign_in_path) && return
  end

  def show

    # 該当するユーザのidを取得
    @user = User.find(params[:id])
    # 紐付いているからidのみ取得するだけでいい
    @posts = Post.where(user_id: @user.id)
  end

  # プロフィール編集ページ
  def edit
    @user = User.find(current_user.id)
  end

  # プロフィール更新処理
  def update
    @user = User.new(user_params)
    upload_file = params[:user][:image]

    # 画像があった場合に代入
    if upload_file.present?
      # 画像のファイル名取得
      upload_file_name = upload_file.original_filename

      output_path = output_dir + upload_file_name

      File.open(output_path, 'w+b') do |f|
        f.write(upload_file.read)
      end

      # データベースに更新
      current_user.update(user_params.merge(image: upload_file.original_filename))

    else
      current_user.update(user_params)

    end
    redirect_to profile_path(current_user)
  end
  
  # フォロー処理
  def follow
    @user = User.find(params[:id])
    
    if Follow.exists?(user_id: current_user.id, follow_user_id: @user.id)
      # フォローを解除
      Follow.find_by(user_id: current_user.id, follow_user_id: @user.id).destroy
    else
      # フォローする
      Follow.create(user_id: current_user.id, follow_user_id: @user.id)
    end
    redirect_back(fallback_location: top_path, notice: "フォローを更新しました。")
  end
  
  # フォローリスト
  def follow_list
      # プロフィール情報の取得
      @user = User.find(params[:id])
      @users = User.where(id: Follow.where(user_id: @user.id).pluck(:follow_user_id))
  end
  
  # フォローリスト
  def follower_list
      # プロフィール情報の取得
      @user = User.find(params[:id])
      # ここに処理を実装
      # followsテーブルから、フォローしているユーザーIDを取得する
      # follow_user_idはされる側 user_idはする側
      ids = Follow.where(follow_user_id: @user.id).pluck(:user_id)
      # usersテーブルから、1で取得したユーザーIDに紐づくユーザーの情報を取得する
      @users = User.where(id: ids)
  end
  

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :comment)
  end

  def output_dir
    Rails.root.join('public', 'users')
  end
end
