require 'gmail'       #gem gmail
require 'google_drive' #gem to get on google sheet
require 'rubygems'      
require 'io/console'   #required so you can type your password in a blind field

def get_the_email_html  #this methode returns a string of a html code with the name of the town given in argument in it

	return "<h1>Bonjour</h1>
					<p>Je m'appelle Mati, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau.<br> La formation s'appelle The Hacking Project (http://thehackingproject.org/).<br> Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours (par exemple envoyer des mails via ruby), sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.</p>
					<p>Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à pomme, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées.<br> Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec !</p>
					<p><strong>Charles, co-fondateur de The Hacking Project</strong> pourra répondre à toutes vos questions : 06.95.46.60.80</p>"

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