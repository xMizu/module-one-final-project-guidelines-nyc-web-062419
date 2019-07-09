
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
    new_user = gets.chomp
  if User.find_by(name: new_user.downcase.to_s) == nil
      @user = User.create(name: new_user.downcase.to_s)
    puts "Welcome #{new_user.downcase.capitalize}"

    main_menu
  else
    puts "Sorry, that username is taken. Please log in or enter a new username"
    login_menu
  end
end

def login
    puts "Please enter the username"
    existing_user = gets.chomp
    if User.find_by(name: existing_user.downcase.to_s) == nil
    puts "Username not found. Please create an account or try again"
    login_menu
  else
    @user = User.find_by(name: existing_user.downcase.to_s)
    puts "Welcome #{existing_user.capitalize}"
    main_menu
  end
end

  def main_menu
    prompt = TTY::Prompt.new
    puts "Please select a menu option"
    prompt.select('') do |menu|
    menu.choice 'Saved Articles', -> { saved_articles }
    menu.choice 'Search for new articles', -> { new_search }
    menu.choice 'Exit', -> { exit }
  end
end



  def new_search
    prompt = TTY::Prompt.new
    prompt.select('') do |menu|
    menu.choice 'Trending Stories', -> { trending }
    menu.choice 'Search by Category', -> { articles_by_category }
    menu.choice 'Search by Keyword', -> { articles_by_keyword }
    menu.choice 'Exit back to menu ', -> { main_menu }
    menu.choice 'Exit', -> { exit }
  end
end

def trending
  prompt = TTY::Prompt.new
  their_choice_or_answer = prompt.select('') do |menu|
  Article.all.each do |articles|
  menu.choice "#{articles.title}"
  # binding.pry
    # Article.find_by(title: articles.title).content
end
end
  selected_article = Article.find_by(title: their_choice_or_answer)
  puts "Article Description"
  puts selected_article.description
  puts "Would you like to save this story?"
  prompt = TTY::Prompt.new
  user_response = prompt.select('') do |menu|
    menu.choice 'Save'
    menu.choice 'Browse more stories ', -> {go_back}
  end
  if user_response == "Save"
  Favorite.create(user_id: @user.id,article_id: selected_article.id)
  puts "Saved!"
  binding.pry
  main_menu
end
end

def saved_articles
  @user.articles.each do |articles|
    puts articles.title
  end
end





def go_back
  trending
end

# def trending
#   trending_list = Article.all.map do |articles|
#     puts "#{articles.id}. articles|
#
#
#
#
#   #   puts "#{index + 1}. " + articles.title
#   # end
#   # puts "Select the article you want"
#   # answer = gets.chomp.to_i
#   # binding.pry
#   # trending_list.select do |trending|
#   #   trending_index = answer - 1
#
# end
# end
