require 'gmail'       #gem gmail
require 'google_drive' #gem to get on google sheet
require 'rubygems'      
require 'io/console'   #required so you can type your password in a blind field

def get_the_email_html  #this methode returns a string of a html code with the name of the town given in argument in it

	return "<h1>Bonjour</h1>
					
    <p>
        <strong>Bonjour, nous sommes des jeunes développeur web, de la formation The Hacking Project, nous vous sollicitons afin de promouvoir  les formations que cette organisme propose, je vous prie de trouver ci join un lien vers notre landing page.<br>http://bit.ly/2oidxFY<br>Merci d'avoir pris le temps de nous lire<br><br>Veuillez accepter nos respectueuses salutation   </strong> </p>
					
<p>The Hacking Project est une formation qui propose des cursus gratuits, professionnalisants, à plein temps, ouverts à tous, et sans pré-requis. Nous utilisons le modèle du peer-learning (groupes autonomes, apprentissage par projets concrets, grande communauté) pour émuler un esprit de corps et stimuler le cerveau vers un apprentissage ludique. Et cela nous permet d'être gratuits et accessibles à tous.</p>
					<p>
                        <strong>Charles Dacquay, co-fondateur de The Hacking Project</strong> pourra répondre à toutes vos questions : 06.95.46.60.80
                    </p>
                    <p>
                        <strong>Félix Gaudé, co-fondateur de The Hacking Project</strong> pourra répondre à toutes vos questions : 06 28 01 33 40</p>"

end


def send_email_to_line(dest) #methode that uses gmail gem to send an email to the destination in argument and gives to the html methode the name of the town given in arguments too

	gmail = Gmail.connect($email, $pass) #connection line uses a cross function variable ($)

		if gmail.logged_in? then puts "connected" else puts "offline" end # tells us if the login worked
		
		gmail.deliver do #generating email
			puts "preparing email for #{dest}" #warn us that we entered the function that will send a mail to the town in arg at the email in arg
		  to dest #gets back the destination from the arg
  		subject "The Hacking Project" #subject of the mail
  		html_part do # function used to write a mail in html code
  			content_type 'text/html; charset=UTF-8' #encoding parametters
  			body get_the_email_html			#calling the content of the mail from the methode above and giving it the name of the town so it can modify it in the html
  		end
  	end

  puts "sent" #when done prints a sent
	gmail.logout #disconnect from email address
end

def go_through_all_the_lines()  #methode to read all the lines of the google sheet
	g_session = GoogleDrive::Session.from_config("config.json") #starting drive session from the config.json 's keys'
	w_sheet = g_session.spreadsheet_by_key("1M1vJ2XhdkrV2JvmHb5RauwYmHlHWv1k-AbdXTFx7Ti8").worksheets[0] #asking for the first page of the google sheet at that link

	(1..w_sheet.num_rows).each do |x| #for each lines of the sheet ...

		mail_addresse = w_sheet[x, 1]  #the mail is in the 2nd column
		puts "\n---------------------------------" # bar to split the differents notification at every loop ... cleaner on the console
		puts "sending mail to : #{mail_addresse}"      # warning us that it will send a mail to current city
		if mail_addresse.include?("@") then send_email_to_line(mail_addresse)end #if the cell where the email is supposed to be has a email adress it goes to the email methode

	end

end

def lets_make_this_work() #initializing methode takes no argument

	puts "Welcome to my TownHall spam program ;)" #welcoming line
	puts "--------------------------------------\n \n"#splitting line

	puts "Please enter your email address :"  #asks user to write its email adress
	$email = gets.chomp #saves what the user enter in to a cross function variable
	puts "Password ? (this is a blind field)" #askes user to write its password
	$pass = STDIN.noecho(&:gets).chomp #uses a blind field to type safely  the email's password (refer to require'io/console') and get the password into a cross functions variable


	go_through_all_the_lines()  #gets to the methode that starts reading the sheet

end


lets_make_this_work() #starts the program