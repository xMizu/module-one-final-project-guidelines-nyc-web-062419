require "rest-client"
require "json"
require "pry"

def us
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end

def gb
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=gb&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end

def ca
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=ca&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end

def au
    response_string = RestClient.get("https://newsapi.org/v2/top-headlines?country=au&apiKey=19c889cb66ec40159a52b7cefa4c2b6c")
    response_hash = JSON.parse(response_string)
end


def list_of_countries
    [us,gb,ca,au]
end

def news_list
    list_of_countries.each do |country|
        article = country["articles"]
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
end

news_list