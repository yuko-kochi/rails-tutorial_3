class User < ApplicationRecord
  attr_accessor :remember_token

  # before_saveというコールバック
  # ユーザーをデータベースに保存する前にemail属性を強制的に小文字に変換
  # selfは現在のユーザーを指す
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  # formatオプションの引数に正規表現 (Regular Expression) (regexとも呼ばれる)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,  length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # セキュアにハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存できるようになる
  # 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる
  # 存在性と値が一致するかどうかのバリデーションも追加される
  # authenticateメソッドが使えるようになる (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド)
  # 「!!」(「バンバン (bang bang)」) という演算子を使うと、そのオブジェクトを2回否定することになるので、どんなオブジェクトも強制的に論理値に変換できる
  # !!user.authenticate("パスワードと一致する文字列")だと => true を返す
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

end