class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :source_name
      t.text :content
      t.datetime :publishedAt
    end
  end
end
