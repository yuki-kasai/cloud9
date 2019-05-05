class User < ApplicationRecord
  # リレーション
  has_many :posts

  # データの保存前に、パスワードを暗号化するメソッド(convert_password)を実行するよう設定
  before_create :convert_password

  # パスワードを暗号化するインスタンスメソッド
  #   クラス名.クラスメソッド名（クラスからしか呼び出せない）
  def convert_password
    self.password = User.generate_password(password)
  end

  # パスワードをmd5に変換するselfでクラスメソッド
  def self.generate_password(password)
    # パスワードに適当な文字列を付加して暗号化する
    salt = 'h!hgamcRAdh38bajhvgai17ysvb'
    Digest::MD5.hexdigest(salt + password)
  end

  #   22-3
  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # プロフィール画像がなかったらダミー画像を指定する
  def image_url(user)
    if user.image.blank?
      'https://dummyimage.com/200x200/000/fff'
    else
      "/users/#{user.image}"
    end
  end
end
