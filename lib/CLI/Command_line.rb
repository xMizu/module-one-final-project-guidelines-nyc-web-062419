class Cli

  attr_accessor :user , :article

  def welcome
    puts "Welcome to Flatiron News"
    puts "Please login or create a new username"
    login_menu
  end

    def login_menu
    prompt = TTY::Prompt.new
    prompt.select('') do |menu|
      menu.choice 'Login', -> { login }
      menu.choice 'Create Username', -> { create_username }
      menu.choice 'Exit', -> { exit }
    end
  end


def create_username
    puts "Please enter the username you would like to create"
    new_user = gets.chomp.downcase.to_s
  if User.find_by(name: new_user) == nil
      @user = User.create(name: new_user)
    puts "Welcome #{new_user.capitalize}"
    main_menu
  else
    puts "Sorry, that username is taken. Please log in or enter a new username"
    login_menu
  end
end

def login
    puts "Please enter the username"
    existing_user = gets.chomp.downcase.to_s
    if User.find_by(name: existing_user) == nil
    puts "Username not found. Please create an account or try again"
    login_menu
  else
    @user = User.find_by(name: existing_user)
    puts "Welcome #{existing_user.capitalize}"
    main_menu
  end
end

  def main_menu
    prompt = TTY::Prompt.new
    puts "Please select a menu option"
    prompt.select('') do |menu|
    menu.choice "Saved Articles (#{user.favorites.count})", -> { saved_articles }
    menu.choice 'Search for new articles', -> { new_search }
    menu.choice 'Logout', -> { welcome }
    menu.choice 'Exit', -> { exit }
  end
end



  def new_search
    prompt = TTY::Prompt.new
    prompt.select('') do |menu|
    menu.choice "Trending Stories (#{Article.sort_by_recent.count})", -> { trending }
    # menu.choice 'Search by Description', -> { articles_by_description }
    menu.choice 'Search by Keyword', -> { articles_by_keyword }
    menu.choice 'Return to main menu ', -> { main_menu }
    menu.choice 'Exit', -> { exit }
  end
end

def trending
  prompt = TTY::Prompt.new
  answer = prompt.select('') do |menu|
  Article.sort_by_recent.each do |articles|
  menu.choice "#{articles.title}"
end
  menu.choice "Go back", -> {new_search} 
end
  save answer
  prompt.select('') do |menu|
    menu.choice "New search", -> {new_search}  
    menu.choice "Go back", -> {trending} 
  end
end


def articles_by_keyword
  puts "Insert keyword"
  keyword = gets.chomp.downcase
  search = Article.all_titles.select do |title|
    title.downcase.include?(keyword)
  end
  if search.empty?
    puts "No articles found, please try again"
    new_search
  else
    prompt = TTY::Prompt.new
    answer = prompt.select('') do |menu|
      search.each do |search_result|
        menu.choice search_result 
      end 
    end
  end
  save answer
  saved_articles
end

# def articles_by_description
#   puts "Insert keyword"
#   keyword = gets.chomp.to_s
#   search = Article.all.select do |articles|
#     articles.description.include?(keyword)
#   end
# end

def saved_articles
  prompt = TTY::Prompt.new
  respsonse = prompt.select('') do |menu|
    User.find_by(id: @user.id).articles.each do |article|
      menu.choice article.title, -> {display article}
    end
      menu.choice 'Return to menu ', -> { main_menu }
    end
    prompt.select('') do |menu|
      menu.choice "Read more online", -> {system "open", article.url}
      menu.choice "Go back", -> {saved_articles}
      menu.choice "Remove from favorites", -> {Favorite.delete(Favorite.where(user_id: @user.id,article_id: @article.id))}
    end
  saved_articles
end


def save(answer)
  selected_article = Article.find_by(title: answer)
  puts "Article Description"
  puts selected_article.description
  puts "Would you like to save this story?"
  prompt = TTY::Prompt.new
  user_response = prompt.select('') do |menu|
    menu.choice 'Save'
    menu.choice 'New search', -> {new_search}
  end
  if user_response == "Save"
    if Favorite.find_by(user_id: @user.id,article_id: selected_article.id)
      puts "Already saved!"
    else Favorite.create(user_id: @user.id,article_id: selected_article.id)
      puts "Saved!"
    end
  end
end
 
def display article
  @article = article
  puts article.title
  puts "------------------"
  if article.description.class == String
    puts article.description
  end
  if article.content.class == String
    puts article.content
  end
end




end
