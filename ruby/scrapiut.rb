require 'rubygems'
require 'watir'
require "google_drive"
require 'json'

class Scrapiut

	def initialize

		@browser = Watir::Browser.new :firefox
		@session = GoogleDrive::Session.from_config("config.json")
		@ws = @session.spreadsheet_by_key("1M1vJ2XhdkrV2JvmHb5RauwYmHlHWv1k-AbdXTFx7Ti8").worksheets[0]

	end

	def perform

		puts "Entering www.sup.adc.education.fr/iutlst ..."
		@browser.goto("https://www.sup.adc.education.fr/iutlst/")

	 	@emails = []
	 	@i = 1

	 	puts "Collecting emails ..."
		@links = @browser.links.collect(&:text)

		@links.each do |link|
		 	if link.include? '@'
	  			@ws[@i,1] = link
		  		@i += 1
			end

		end

		puts "writting on google drive"

		@ws.save 

		puts "saved!" 

		puts "------------------------------------------------\nend of program"

		@browser.close

	end

end

Scrapiut.new.perform