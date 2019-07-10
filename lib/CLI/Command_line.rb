class Cli

  attr_accessor :user , :article

  Prompt = TTY::Prompt.new
  Pastel = Pastel.new

  def welcome
    system 'clear'
    puts Pastel.bold.underline "Welcome to Flatiron News"
    puts "Please login or create a new username"
    login_menu
  end

    def login_menu
    Prompt.select('') do |menu|
      menu.choice Pastel.red('Login'), -> { login }
      menu.choice Pastel.blue('Create Username'), -> { create_username }
      menu.choice 'Exit', -> { exit }
    end
  end


def create_username
  system "clear"
    puts Pastel.bold.underline "Please enter the username you would like to create"
    puts " "
    new_user = gets.chomp.downcase.to_s
  if User.find_by(name: new_user) == nil
      @user = User.create(name: new_user)
      system "clear"
    puts Pastel.bold.underline "Welcome #{new_user.capitalize}"
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
    puts Pastel.bold.underline "Please enter the username"
    puts " "
    existing_user = gets.chomp.downcase.to_s
    if User.find_by(name: existing_user) == nil
    puts Pastel.bold.red "Username not found. Please create an account or try again"
    login_menu
  else
    @user = User.find_by(name: existing_user)
    system "clear"
    puts Pastel.bold.underline "Welcome #{existing_user.capitalize}"
    puts " "
    main_menu
  end
end

  def main_menu
    system "clear"
    puts Pastel.bold.underline "Welcome #{user.name.capitalize}"
    puts " "
    puts "Please select a menu option"
    Prompt.select('') do |menu|
    menu.choice "Saved Articles (#{user.favorites.count})", -> { saved_articles }
    menu.choice 'Search for new articles', -> { new_search }
    menu.choice 'Logout', -> { welcome }
    menu.choice 'Exit', -> { exit }
  end
end



  def new_search
    system "clear"
    puts Pastel.bold.underline "Please select a search option"
    puts " "
    Prompt.select('') do |menu|
    menu.choice "Trending Stories (#{Article.sort_by_recent.count})", -> { trending }
    # menu.choice 'Search by Description', -> { articles_by_description }
    menu.choice 'Search by Keyword', -> { articles_by_keyword }
    menu.choice 'Return to main menu ', -> { main_menu }
    menu.choice 'Exit', -> { exit }
  end
end

def trending
  system "clear"
  puts Pastel.bold.underline "Here are todays trending stories"
  puts " "
  answer = Prompt.select(" ", " ", per_page: 200) do |menu|
  Article.sort_by_recent.each do |articles|
  menu.choice "#{articles.title}"
end
  menu.choice "Go back", -> {new_search}
end
  save answer
  Prompt.select('') do |menu|
    menu.choice "New search", -> {new_search}
    menu.choice "Go back", -> {trending}
    menu.choice "See favorites", -> {saved_articles}
  end
end


def articles_by_keyword
  system "clear"
  puts "Insert keyword"
  keyword = gets.chomp.downcase
  search = Article.sort_by_recent.select do |article|
    article.title.downcase.include?(keyword)
  end
  if search.empty?
    system "clear"
    puts Pastel.bold.red "No articles found, please try again"
    puts " "
    Prompt.select('') do |menu|
      menu.choice 'Search by Keyword', -> { articles_by_keyword }
      menu.choice 'Return to main menu ', -> { main_menu }
    end
  else
    answer = Prompt.select('', per_page: 200) do |menu|
      search.each do |search_result|
        menu.choice search_result.title
      end
      puts " "
      menu.choice 'Search by Keyword', -> { articles_by_keyword }
      menu.choice 'Return to main menu ', -> { main_menu }
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
  system "clear"
  puts Pastel.bold.underline "Here are your favorited stories "
  puts " "
  respsonse = Prompt.select('', per_page: 200) do |menu|
    User.find_by(id: @user.id).articles.each do |article|
      menu.choice article.title, -> {display article}
    end
      menu.choice 'Return to menu ', -> { main_menu }
    end
    Prompt.select('') do |menu|
      menu.choice "Read more online", -> {system "open", article.url}
      menu.choice "Go back", -> {saved_articles}
      menu.choice "Remove from favorites", -> {Favorite.delete(Favorite.where(user_id: @user.id,article_id: @article.id))}
    end
  saved_articles
end


def save(answer)
  selected_article = Article.find_by(title: answer)
  system "clear"
  display selected_article
  puts " "
  puts "Would you like to save this story?"
  user_response = Prompt.select('') do |menu|
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
  system "clear"
  puts Pastel.bold.underline "Title"
  puts " "
  @article = article
  puts article.title
  puts " "
  puts Pastel.bold.underline "Description"
  puts " "
  if article.description.class == String
    puts article.description
  end
end




end
