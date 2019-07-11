class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :article_id
      t.integer :user_id
      t.text :comment
      t.datetime :comment_timestamp
    end 
  end
end
