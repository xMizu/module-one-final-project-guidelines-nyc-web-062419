require "rest-client"
require "json"
require "pry"

class Article < ActiveRecord::Base
    has_many :favorites
    has_many :users, through: :favorites

# def self.news
#     response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
#     response_hash = JSON.parse(response_string)
# end

# def self.news_list
#     # article = 
#     # self.news.map do |data,info|
#     #     if data == "articles"   
#     #         info
#     #     end           
#     # end.compact.flatten

#     # news = 
#     # article.each do |hash|
#     #     Article.create(
#     #         title: hash["title"],
#     #         description: hash["description"],
#     #         url: hash["url"],
#     #         content: hash["content"],
#     #         publishedAt: hash["publishedAt"])
#     # end

#     news

# end

end