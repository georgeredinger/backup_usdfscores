#require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'

Capybara.run_server = false
Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit
Capybara.app_host = 'http://www.usdf.org'
Capybara.default_wait_time = 10
    def getit(user_num,password,name)
        include Capybara::DSL
        visit("/usdfscores/login.asp")
        fill_in 'UserNum', :with => user_num
        fill_in 'password', :with => password
        click_button('Submit')
        fill_in "q", :with => name
        sleep(5)
        not_found=page.find('.autocomplete').nil? #this is supposed to cause capybara to wait for ajax response, but alias, it does not seem to, hence, the sleep()
        if not_found
            puts "#{name} not found"
            return
        end
        names = all(:css, "div.autocomplete div")

        names.each do |a|
            puts a.text
        end

        names[0].click
        sleep(5)
        click_button("Search")
        sleep(5)
        click_button("Switch to Lifetime Score Check")
        sleep(5)
        scores=page.all(:xpath,"//html/body/div/div[2]/div/div/div[2]/div[2]/div/div/div/table/tbody/tr")
        scores[1..-1].each do |rows| 
        #   puts rows.text
            rows.all(:css,"td").each do |cells|
                print "#{cells.text} |"
            end
            puts
        end
    end

getit(ARGV[0],ARGV[1],ARGV[2])



