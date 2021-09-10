class User < ApplicationRecord

  # before_saveというコールバック
  # ユーザーをデータベースに保存する前にemail属性を強制的に小文字に変換
  # selfは現在のユーザーを指す
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  # formatオプションの引数に正規表現 (Regular Expression) (regexとも呼ばれる)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,  length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

end


