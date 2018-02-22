require "twitter"
require 'dotenv'

class Tweetbot

	Dotenv.load
	
	def initialize

		$client_stream = Twitter::Streaming::Client.new do |config|
		  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
		  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
		  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
		  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
		end

		$client_action = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
		  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
		  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
		  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
		end

	end

	def perform

		topics = ["Formation web",
              "informatique",
              "formation programmation",
              "formation code",
              "formation codage",
              "ecole42",
              "Eptita",
              "developpement web",
              "lewagon",
              "Formation web HTML CSS Ruby on Rails",
              "formation informatique",
              "Formation programmation web",
              "Formation codage informatique Ruby on Rails",
              "Formation web HTML CSS",
              "formation Ruby on rails",
              "apprendre web",
              "apprendre programmation",
              "apprendre code",
              "apprendre codage",
              "apprendre web HTML CSS Ruby on Rails",
              "apprendre programmation web",
              "apprendre codage informatique Ruby on Rails",
              "apprendre web HTML CSS",
              "apprendre codage web",
              "apprendre code web",
           	  "apprendre à coder"]

		puts "Listening for \n #{topics}"
		puts "--------------------------"

		$client_stream.filter(track: topics.join(","), geocode: "48.8566667,2.3509871,50mi") do |object|

  		 if object.is_a?(Twitter::Tweet)  
  		 	begin

  		 		puts "\n @#{object.user.screen_name} tweeted :"
  		 		puts object.text
  		 		
  		 		$client_action.favorite!(object)
  		 		puts "\nresponding to @#{object.user.screen_name}"
  		 		$client_action.update("Salut @#{object.user.screen_name}! Tu veux apprendre à coder gratuitement ? Viens découvrir The Hacking Project, une formation d'un nouveau genre ! http://bit.ly/2oidxFY ", in_reply_to_status_id: object.id)
  		 		puts "\n ----------------------------------- \n"
  		 	rescue Twitter::Error
  		 		puts "already treated"
  		 	end


  	end 

	end


	end

	
end

Tweetbot.new.perform


