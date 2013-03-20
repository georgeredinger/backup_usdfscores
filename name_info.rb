require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'json'

class Scores
    include Capybara::DSL
    def initialize(user_num,password,query)
        @user_num=user_num
        @password=password
        @query =query
        @info = {}
        @info["scores"] = []
        Capybara.run_server = false
        Capybara.default_driver = :webkit
        Capybara.javascript_driver = :webkit
        Capybara.app_host = 'http://www.usdf.org'
        Capybara.default_wait_time = 10
    end
    def get_em
        visit("/usdfscores/login.asp")
        fill_in 'UserNum', :with => @user_num
        fill_in 'password', :with => @password
        click_button('Submit')
        fill_in "q", :with => @query
        sleep(5)
        not_found=page.find('.autocomplete').nil? #this is supposed to cause capybara to wait for ajax response, but alias, it does not seem to, hence, the sleep()
        if not_found
            @info["scores"] <<  "#{@query} not found"
            return @info
        end
        names = all(:css, "div.autocomplete div")

        names.each do |a|
            usdf_number = a.text[/\([0-9]+\)/][/[0-9]+/]
            @info["name"] = a.text[/.*\(/][0..-2]
            @info["usdf_number"] = usdf_number
        end

        names[0].click
        sleep(5)
        click_button("Search")
        sleep(5)
        click_button("Switch to Lifetime Score Check")
        sleep(5)
        scores=page.all(:xpath,"//html/body/div/div[2]/div/div/div[2]/div[2]/div/div/div/table/tbody/tr")
        @info["scores"]=Array.new
        @info["AAK"] = page.current_url
        if page.current_url =~ /info-rider\.asp/
            its_a_horse = false
            @info["type"]="human"
        else
            @info["type"]="horse"
            its_a_horse = true
        end

        scores[1..-1].each_with_index do |rows,index| 
            cell = rows.all(:css,"td")
            @info["scores"][index] = Hash.new
            @info["scores"][index]["Date"]=cell[0].text
            @info["scores"][index]["Competition"]=cell[1].text
            @info["scores"][index]["Class"]=cell[2].text
            @info["scores"][index]["Level"]=cell[3].text
            @info["scores"][index]["Test"]=cell[4].text
            if its_a_horse 
              @info["scores"][index]["Owner"]=cell[5].text
              @info["scores"][index]["Rider"]=cell[6].text
              offset=0
            else
              @info["scores"][index]["Horse"]=cell[5].text
              offset=-1
            end

            @info["scores"][index]["Judges"]=cell[7+offset].text
            @info["scores"][index]["Special_Designation"]=cell[8+offset].text
            @info["scores"][index]["Score"]=cell[9+offset].text
            if cell[10+offset] != nil
                @info["scores"][index]["Placing"]=cell[10+offset].text
            end
        end
        @info
    end
end
#scores = Scores.new(ARGV[0],ARGV[1],ARGV[2])
#puts scores.get_em.to_json



