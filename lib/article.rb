require "rest-client"
require "json"
require "pry"

class Article < ActiveRecord::Base
    has_many :favorites
    has_many :users, through: :favorites

    def self.all_titles
        self.all.map do |article|
            article.title
        end
    end

    def self.sort_by_recent
        self.order(publishedAt: :desc).limit(25)
    end




end
