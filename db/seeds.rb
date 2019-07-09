require "rest-client"
require "json"
require "pry"

def news
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end


def news_list
    article = news["articles"]

    news =
        article.each do |hash|
            if Article.find_by( title: hash["title"])
            
            else
                Article.create(
                title: hash["title"],
                description: hash["description"],
                url: hash["url"],
                content: hash["content"],
                publishedAt: hash["publishedAt"])
            end
        end
end

news_list