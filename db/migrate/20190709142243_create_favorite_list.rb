class CreateFavoriteList < ActiveRecord::Migration[5.0]
  def change
    create_table :favouritelists do |t|
      t.integer :user_id
      t.integer :articles_id
    end
  end
end
