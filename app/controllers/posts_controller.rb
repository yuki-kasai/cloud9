class PostsController < ApplicationController
  # アクション処理に入る前に認証
  before_action :authorize

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    upload_file = params[:post][:upload_file]

    # 投稿画像がない場合
    if upload_file.blank?
      flash[:danger] = '投稿には画像が必須です。'
      redirect_to(new_post_path) && return
    end

    # 画像のファイル名取得
    upload_file_name = upload_file.original_filename

    output_path = output_dir + upload_file_name

    File.open(output_path, 'w+b') do |f|
      f.write(upload_file.read)
    end

    @post.post_images.new(name: upload_file_name)

    if @post.save
      # 成功
      flash[:success] = '新規投稿しました'
      redirect_to(top_path) && return
    else
      # 失敗
      flash[:danger] = '画像の保存に失敗しました'
      redirect_to(new_post_path) && return
    end
  end

  private

  # mergeで画像と説明文以外にidも必要なので追加するメソッド
  def post_params
    params.require(:post).permit(:caption).merge(user_id: current_user.id)
  end

  def output_dir
    Rails.root.join('public', 'images')
  end
end
