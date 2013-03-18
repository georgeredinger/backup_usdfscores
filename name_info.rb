#require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'pry'

Capybara.run_server = false
Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit
Capybara.app_host = 'http://www.usdf.org'


    def getit(user_num,password,name)
        include Capybara::DSL
        visit("/usdfscores/login.asp")
        fill_in 'UserNum', :with => user_num
        fill_in 'password', :with => password
        click_button('Submit')
        fill_in "q", :with => name
        sleep(5)
        names = all(:css, "div.autocomplete div")
        names.each do |a|
            puts a.text
        end


    end

getit(ARGV[0],ARGV[1],ARGV[2])



