require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require "date"

require_relative 'expense_class'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  set :erb, :escape_html => true
end

get "/" do
  unless session[:expenses]
    current_month = Time.now.strftime("%B")
    session[:expenses] = Expenses.new(current_month)
    session[:categories] = session[:expenses].categories
    session[:limit] = session[:expenses].limit
  end

  session[:total_spent] = session[:expenses].total_list_amount

  erb :main
end

def valid_expense_input?(name, amount, category)
  name.strip.size > 0 && 
  amount.to_i >= 0 && 
  (1..session[:categories].size).include?(category.to_i)
end

get "/new" do
  erb :new
end

post "/new/expense" do
  name = params[:name]
  amount = params[:amount]
  category = params[:category]

  if valid_expense_input?(name, amount, category)
    session[:expenses].new_expense(name, amount, category)
    session[:message] = "Expense added successfully."
    redirect "/"
  else
    session[:message] = "Invalid input. Try again."
    status 422
    erb :new
  end
end

post "/new/category" do
  new_category = params[:category]

  if !(new_category.strip.size > 0)
    session[:message] = "Category added successfully."
    erb :new
  else
    session[:categories] << params[:category]
    session[:message] = "Category added successfully."
    redirect "/new"
  end
end



# Build delete function (- using item ids)
# add new category
