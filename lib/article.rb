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
    self.news.map do |data,info|
        data == "articles"               
    end
end




# def query
#     puts "hello"
#     input = ""
#     input = gets.chomp
# case input
# when "headlines"
#     puts "Pleases select country"
#     print "United States"
#     print "United Kingdom"
#     country = gets.chomp
#     if country == "United States"
#         country = "us"
#     else country == "United Kingdom"
#         country = "uk"
#     end
#     news("top-headlines?country=#{country}")
# when "search by categories"
#     list = ["Business", "Entertainment", "Science","Sports","Technology"]
#     search = gets.chomp
#     list.include?(search)
#     news("everything?q=#{search.lower}")
# when "exit"
#     exit
# else
#     puts "Menu"
# end
# end

end