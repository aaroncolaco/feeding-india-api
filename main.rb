require 'sinatra'
require './feeders'
require 'json'
require 'open-uri'
require 'mail'

# Reload if in development mode
require 'sinatra/reloader' if development?

set :success, 'success'
set :auth_error, 'auth_error'
set :does_not_exist, 'does_not_exist'
set :already_exists, 'already_exists'
set :insufficient_parameters, 'insufficient_parameters'
set :not_found_error, 'not_found'
set :common_error, 'something_happened'

# for development
configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/feeders.db")
	# DataMapper.setup(:donations, "sqlite3://#{Dir.pwd}/donations.db")
end

# DB for production
configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
	# DataMapper.setup(:donations, ENV['DATABASE_URL'])
end

get '/' do
	'Using SendGrid to send emails to admin of this application'
end

# Retrieve User Data
get '/feeders/:email' do
	user_data = get_user(params[:email].to_s)

	if user_data.nil?
		return settings.does_not_exist
	end

	content_type :json
	user_data.to_json
end

# Sign in
post '/signin/:email' do
	user_data = get_user(params[:email].to_s)

	if user_data.nil?
		return settings.does_not_exist
	end

	content_type :json
	user_data.to_json
end

# Sign up
post '/signup/:email' do

	user_data = get_user(params[:email].to_s)
	
	if user_data.nil?

		# Additional parameters passed
		name = params[:name].to_s
		phone = params[:phone].to_s
		state = params[:state].to_s
		address = params[:address].to_s

		if (name.nil? || phone.nil? ||
			state.nil? || address.nil?)
			return settings.insufficient_parameters
		end

		if (name == '' || phone == '' ||
			state == '' || address == '')
			return settings.insufficient_parameters
		end


		feeder = Feeders.new

		feeder.email = params[:email].to_s
		feeder.name = name
		feeder.phone = phone
		feeder.state = state
		feeder.address = address
		# feeder.pincode = params[:pincode].to_s
		feeder.times_fed = 0

		feeder.save
		
		content_type :json
		get_user(feeder.email).to_json
	else
		return settings.already_exists	
	end
end

# Make donation
post '/donate/:email' do

	user_data = get_user(params[:email].to_s)

	if user_data.nil?
		return settings.does_not_exist
	end

	email = params[:email].to_s
	description = params[:description].to_s
	time = params[:time].to_s

	# Additional parameters passed
	url = params[:url].to_s
	description = params[:description].to_s
	time = params[:time].to_s
	foodtype = params[:foodtype].to_s
	packing = params[:packing].to_s
	foodfor = params[:foodfor].to_s
	location = params[:location].to_s

	# Check if required parameters are present
	if (url.nil? || description.nil? || time.nil? || 
		foodtype.nil? || packing.nil? || foodfor.nil?)
		return settings.insufficient_parameters
	end

	if (url == '' || description == '' || time == '' || 
		foodtype == '' || packing == '' || foodfor == '')
		return settings.insufficient_parameters
	end

	food_info = "\n\nDescription: " + description + "\nFoodtype: " + foodtype + 
		"\nPackaging: " + packing + "\nFood for: " + foodfor + 
		"\nPreferable pickup time: " + time +
		"\n\nImage: " + url

	# If location passed, use
	if location != ''
		food_info = food_info + "\n\nLocation: " + location
		status = send_mail(email, food_info, true)
	else
		status = send_mail(email, food_info, false)
	end

	# Downloads file to attach it later
	# File.open('tmp/image.png', 'wb') do |fo|
	# 	fo.write open(url).read 
	# end

	return status
end

# All errors
error do
	return settings.common_error
end

# Not Found error
not_found do
	return settings.not_found_error
end



helpers do

	def get_user(email)
		feeder = Feeders.first(:email => email)
		if feeder.nil?
			return nil
		end
		user_data = {
			:email => feeder.email,
			:name => feeder.name,
			:phone => feeder.phone,
			:state => feeder.state,
			:address => feeder.address,
			# :pincode => feeder.pincode,
			:times_fed => feeder.times_fed
		}
		return user_data
	end

	def send_mail (email, food_info, location_added)

		feeder = Feeders.first(:email => email)

		if feeder.nil?
			return settings.does_not_exist
		end

		feeder.times_fed += 1
		feeder.save

		# Create message with donation data
		donation_msg = "Email: " + email + "\nName: " + feeder.name + 
			"\nPhone: " + feeder.phone + "\nState: " + feeder.state + 
			# "\nPin-Code: " + feeder.pincode
			"\nTimes donated:" + feeder.times_fed.to_s + "\n" + food_info

			if !location_added
				donation_msg = donation_msg + "\n\nAddress: " + feeder.address
			end


		# Regular Mail
		# options = { :address				=> "smtp.gmail.com",
		# 			:port					=> 587,
		# 			:domain					=> 'your.host.name',
		# 			:user_name				=> 'pccestuff@gmail.com',
		# 			:password				=> '',	# Add password here 
		# 			:authentication			=> 'plain',
		# 			:enable_starttls_auto	=> true  }


		# Mail.defaults do
		# 	delivery_method :smtp, options
		# end

		# Mail.deliver do
		# 	to 'hhlda@slipry.net' #'aldrichm69@gmail.com'
		# 	from "donator@xyz.com"
		# 	subject 'Food Donation'
		# 	body donation_msg
		# 	add_file "#{Dir.pwd}/tmp/image.png"
		# end

		
		# SendGrid Email

		Mail.defaults do
			delivery_method :smtp, {
				:address => 'smtp.sendgrid.net',
				:port => '587',
				:domain => 'heroku.com',
				:user_name => ENV['SENDGRID_USERNAME'],	# For testing put values
				:password => ENV['SENDGRID_PASSWORD'],	# For testing put values
				:authentication => :plain,
				:enable_starttls_auto => true
			}
		end

		Mail.deliver do
			to 'hungerheroes.developer@gmail.com'
			from 'donator@heroku.com'
			subject 'Donation'
			body donation_msg
			# add_file "#{Dir.pwd}/tmp/image.png"
		end

		return settings.success
	end
end