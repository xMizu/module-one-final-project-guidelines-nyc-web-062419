require "rest-client"
require "json"
require "pry"

class Article < ActiveRecord::Base
    has_many :favorites
    has_many :users, through: :favorites

def self.news
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end

def self.news_list
    article = self.news["articles"]

    news = 
    article.each do |hash|  
        # find if the article exists based on title
        if Article.find_by(title: hash["title"])

        else
        # if it exists do nothing
        # else if it does not exist create new article
        Article.create(
            title: hash["title"],
            description: hash["description"],
            url: hash["url"],
            content: hash["content"],
            publishedAt: hash["publishedAt"])
        end
    end
    news
end

end