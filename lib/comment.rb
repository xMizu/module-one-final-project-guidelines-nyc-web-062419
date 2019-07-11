class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  def self.comment_by_article(article)
    self.all.where(article_id: article.id).each do |comment_instance|
      puts comment_instance.comment
    end
  end


end
