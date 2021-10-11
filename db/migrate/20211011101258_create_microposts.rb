class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    # created_at を付与することによりuser_idに関連付けられたすべてのマイクロポストを作成時刻の逆順で取り出しやすくなる
    # user_idとcreated_atの両方を１つの配列に含めることでActive Recordは、
    # 両方のキーを同時に扱う複合キーインデックス (Multiple Key Index) を作成する
    add_index :microposts, [:user_id, :created_at]
  end
end
