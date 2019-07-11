


class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  Pastel = Pastel.new

  def self.comment_by_article article
    self.all.where(article_id: article.id).each do |ci|
      puts "#{Pastel.bold(ci.comment)} "
      puts "#{Pastel.bright_blue(ci.user.name)}- #{Pastel.yellow(ci.comment_timestamp)} "
      puts "" 
    end
  end


end
