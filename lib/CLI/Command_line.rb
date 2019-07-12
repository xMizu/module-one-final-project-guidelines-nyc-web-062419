class Cli

  attr_accessor :user , :article

  Prompt = TTY::Prompt.new
  Pastel = Pastel.new

  def header
   Pastel.magenta.bold.underline.detach
  end

  def option
    Pastel.detach
  end

  # def selection
  #   Pastel.bright_black.italic.detach
  # end

  def welcome
    system 'clear'
    puts header.call "Welcome to Ruby QuickNews"
    puts "Please login or create a new username"
    login_menu
  end

    def login_menu
    Prompt.select('') do |menu|
      menu.choice (option.call 'Login'), -> { login }
      menu.choice (option.call 'Create Username'), -> { create_username }
      menu.choice (option.call 'Exit'), -> { exit_message }
    end
  end


def create_username
  system "clear"
    puts header.call "Please enter the username you would like to create"
    puts " "
    new_user = gets.chomp.downcase.to_s
  if User.find_by(name: new_user) == nil
      @user = User.create(name: new_user)
      system "clear"
    puts header.call "Welcome #{new_user.capitalize}"
    puts " "
    main_menu
  else
    system "clear"
    puts Pastel.bold.red "Sorry, that username is taken. Please log in or enter a new username"
    login_menu
  end
end

def login
  system "clear"
    puts header.call "Please enter the username"
    puts " "
    existing_user = gets.chomp.downcase.to_s
    if User.find_by(name: existing_user) == nil
    puts Pastel.bold.red "Username not found. Please create an account or try again"
    login_menu
  else
    @user = User.find_by(name: existing_user)
    system "clear"
    puts header.call "Welcome #{existing_user.capitalize}"
    puts " "
    main_menu
  end
end

  def main_menu
    system "clear"
    puts header.call "Welcome #{user.name.capitalize}"
    puts " "
    puts "Please select a menu option"
    Prompt.select('') do |menu|
    menu.choice (option.call "Saved Articles (#{user.favorites.count})"), -> { saved_articles }
    menu.choice (option.call 'Search for new articles'), -> { new_search }
    menu.choice (option.call 'Settings'), -> { settings }
    menu.choice (option.call 'Logout'), -> { welcome }
    menu.choice (option.call 'Exit'), -> { exit_message }
    end
  end

  def settings
    system "clear"
    puts header.call "Settings"
    Prompt.select('') do |menu|
      menu.choice (option.call "Change Name"), -> { change_name }
      menu.choice (option.call 'Delete Account'), -> { delete_account }
      menu.choice (option.call 'Go Back'), -> { main_menu }
    end
  end

  def change_name
    system "clear"
    puts "Enter new username"
    new_name = gets.chomp.downcase.to_s
    @user.update(name: new_name)
    Prompt.select('') do |menu|
      menu.choice (option.call 'Go Back'), -> { main_menu }
    end
  end

  def delete_account
  fav = Favorite.where(user_id: @user.id)
  fav.destroy_all
  com = Comment.where(user_id: @user.id)
  com.destroy_all
   @user.destroy
    welcome
  end


  def new_search
    system "clear"
    puts header.call "Please select a search option"
    puts " "
    Prompt.select('') do |menu|
    menu.choice (option.call "Trending Stories (#{Article.sort_by_recent.count})"), -> { trending }
    menu.choice (option.call "All Stories (#{Article.sort_all.count})"), -> { all_stories }
    # menu.choice 'Search by Description', -> { articles_by_description }
    menu.choice (option.call 'Search by Keyword'), -> { articles_by_keyword }
    menu.choice (option.call 'Return to main menu'), -> { main_menu }
    menu.choice (option.call 'Exit'), -> { exit_message }
  end
end


def all_stories
  system "clear"
  puts header.call "Here are all stories"
  Prompt.select(" ", per_page: 40) do |menu|
    Article.sort_all.each do |articles|
      menu.choice (articles.title), -> {save articles.title}
    end
    menu.choice (option.call "Go back"), -> {new_search}
  end
  Prompt.select('') do |menu|
    menu.choice (option.call "New search"), -> {new_search}
    menu.choice (option.call "Go back"), -> {all_stories}
    menu.choice (option.call "See favorites"), -> {saved_articles}
  end
end

def trending
  system "clear"
  puts header.call "Here are todays trending stories"
  puts " "
  user_choice = Prompt.select(" ", per_page: 200) do |menu|
  Article.sort_by_recent.each do |articles|
  menu.choice (articles.title), -> {save articles.title}
  end
  menu.choice (option.call "Go back"), -> {new_search}
  end
  display article
  Prompt.select('') do |menu|
    menu.choice (option.call "New search"), -> {new_search}
    menu.choice (option.call "Go back"), -> {trending}
    menu.choice (option.call "See favorites"), -> {saved_articles}
  end
end


def articles_by_keyword
  system "clear"
  puts "Insert keyword"
  keyword = gets.chomp.downcase
  search = Article.all.select do |article|
    article.title.downcase.include?(keyword)
  end
  if search.empty?
    system "clear"
    puts Pastel.bold.red "No articles found, please try again"
    puts " "
    Prompt.select('') do |menu|
      menu.choice (option.call 'Search by Keyword'), -> { articles_by_keyword }
      menu.choice (option.call 'Return to main menu'), -> { main_menu }
    end
  else
    answer = Prompt.select('', per_page: 200) do |menu|
      search.each do |search_result|
        menu.choice (search_result.title)
      end
      menu.choice (option.call 'Search by Keyword'), -> { articles_by_keyword }
      menu.choice (option.call 'Return to main menu'), -> { main_menu }
    end

  end
  save answer
  save answer
  Prompt.select('') do |menu|
    menu.choice (option.call "See Favorites"), -> {saved_articles}
    menu.choice (option.call "Go back"), -> {articles_by_keyword}
    menu.choice (option.call "Main Menu"), -> {main_menu}
  end
end

def saved_articles
  system "clear"
  puts header.call "Here are your favorited stories "
  puts " "
  response = Prompt.select('', per_page: 200) do |menu|
    User.find_by(id: @user.id).articles.map do |article|
      menu.choice (article.title), -> {display article}
    end
      menu.choice ('Return to menu'), -> { main_menu }
    end
    Prompt.select('') do |menu|
      menu.choice (option.call "Read more online"), -> {system "open", article.url}
      menu.choice (option.call 'New comment'), -> {new_comment}
      menu.choice (option.call "Go back"), -> {saved_articles}
      menu.choice (option.call "Remove from favorites"), -> {Favorite.delete(Favorite.where(user_id: @user.id,article_id: @article.id))}
      menu.choice (option.call "Main Menu"), -> {main_menu}
    end
  display @article
  user_response = Prompt.select('') do |menu|
    menu.choice (option.call 'Go back'), -> {saved_articles}
    menu.choice (option.call 'Main menu'), -> {main_menu}
end
end


def save answer
  selected_article = Article.find_by(title: answer)
  system "clear"
  display selected_article
  puts " "
  puts "Would you like to save this story?"
  user_response = Prompt.select('') do |menu|
    menu.choice (option.call 'Save')
    menu.choice (option.call 'New search'), -> {new_search}
    menu.choice (option.call 'New comment'), -> {new_comment}
    menu.choice (option.call 'Main Menu'), -> {main_menu}
  end
  if user_response == (option.call 'Save')
    if Favorite.find_by(user_id: @user.id,article_id: selected_article.id)
      puts "Already saved!"
    else Favorite.create(user_id: @user.id,article_id: selected_article.id)
      puts "Saved!"
    end
  end
end

def new_comment
  user_comment = gets.chomp.to_s
  Comment.create(article_id: @article.id, user_id: @user.id, comment: user_comment, comment_timestamp: Time.now)
end

def display article
  system "clear"
  puts header.call "Title"
  puts " "
  @article = article
  puts article.title
  puts " "
  puts header.call "Description"
  puts " "
  # if article.description.class == String
  puts article.description
  puts header.call "Comments"
  puts " "
  Comment.comment_by_article(article)
  end

  def exit_message
    system "clear"
    puts Pastel.bold("Have a nice day")
    exit
  end





end
