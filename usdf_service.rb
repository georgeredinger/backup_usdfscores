require 'sinatra'
require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require './name_info.rb'
require 'json'

# Usage: 
# curl 'localhost:4567?user_number=123&password=password&query=flim%20flam'
# curl 'localhost:4567?user_number=123&password=your_password&query=mary%20jones'
# curl 'localhost:4567?user_number=123&password=your_password&query=54321'
#
set :port, 3000
set :logging, true
 get '/' do
    user_number=params["user_number"]
    password=params["password"]
    query=params["query"]
    scores = Scores.new(user_number,password,query)
    scores.get_em.to_json
 end

