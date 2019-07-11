class User < ActiveRecord::Base
    has_many :comments
    has_many :articles, through: :comments
    has_many :favorites
    has_many :articles, through: :favorites
end
