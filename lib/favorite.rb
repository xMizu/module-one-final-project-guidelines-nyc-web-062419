class Favorite < ActiveRecord::Base
 belongs_to :user
 belongs_to :article


 def self.most_saved
    Article.all.max_by do |article|
        article.users.count
    end.title
 end
end


