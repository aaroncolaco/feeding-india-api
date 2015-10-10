require 'sinatra'
require './feeders'
require 'json'
require 'open-uri'
require 'mail'

# Reload if in development mode
require 'sinatra/reloader' if development?

set :success, 'Successful'
set :auth_error, 'Authentication Error'
set :does_not_exist, 'Account does not exist'
set :already_exists, 'Sorry. You already have an account. Please Sign in'
set :no_img, 'No image url sent'
set :not_found_error, "Not found"
set :common_error, "Something boring happened"


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

#Retrieve User Data
get '/:email' do
	user_email = params[:email].to_s
	
	feeder = Feeders.first(:email => user_email)

	if feeder.nil?
		return settings.does_not_exist
	end

	content_type :json
	{
		:email => feeder.email,
		:name => feeder.name,
		:phone => feeder.phone,
		:state => feeder.state,
		:address => feeder.address,
		:times_fed => feeder.times_fed
	}.to_json
end

#sign_in
post '/login/:email/:password' do
	login_email = params[:email].to_s
	login_password = params[:password].to_s
	
	feeder = Feeders.first(:email => login_email)

	if feeder.nil?
		return settings.does_not_exist
	end

	if feeder.pass == login_password
		content_type :json

		{
			:email => feeder.email,
			:name => feeder.name,
			:phone => feeder.phone,
			:state => feeder.state,
			:address => feeder.address,
			:times_fed => feeder.times_fed
		}.to_json
	else
		return settings.auth_error	
	end
end

#sign_up
post '/feeders/:email/:password/:name/:phone/:state/:address' do

	feeder = Feeders.first(:email => params[:email].to_s)

	if feeder.nil?
		feeder = Feeders.new

		feeder.email = params[:email].to_s
		feeder.pass = params[:password].to_s
		feeder.name = params[:name].to_s
		feeder.phone = params[:phone].to_s
		feeder.state = params[:state].to_s
		feeder.address = params[:address].to_s
		feeder.times_fed = 0

		feeder.save
		
		content_type :json

		{
			:email => feeder.email,
			:name => feeder.name,
			:phone => feeder.phone,
			:state => feeder.state,
			:address => feeder.address,
			:times_fed => feeder.times_fed
		}.to_json
	else
		return settings.already_exists	
	end
end

# Make donation

post '/donation/:email/:description/:time' do

	email = params[:email].to_s
	description = params[:description].to_s
	time = params[:time].to_s

	url = params[:url]

	if url.nil?
		return settings.no_img
	end

	File.open('tmp/image.png', 'wb') do |fo|
		fo.write open(url).read 
	end

	status = send_mail(email, description, time)

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
	def send_mail (email, description, time)

		feeder = Feeders.first(:email => email)

		if feeder.nil?
			return settings.does_not_exist
		end

		# Create message with donation data
		donation_msg = "Email: " + email + "\nName: " + feeder.name + 
			"\nPhone: " + feeder.phone + "\nState: " + feeder.state + 
			"\nAddress: " + feeder.address + "\nDescription: " + 
			description + "\nTime: " + time + 
			"\nTimes Donated: " + feeder.times_fed.to_s

		feeder.times_fed += 1
		
		options = { :address				=> "smtp.gmail.com",
					:port					=> 587,
					:domain					=> 'your.host.name',
					:user_name				=> 'pccestuff@gmail.com',
					:password				=> '',
					:authentication			=> 'plain',
					:enable_starttls_auto	=> true  }


		Mail.defaults do
			delivery_method :smtp, options
		end

		Mail.deliver do
			to 'hhfpu@slipry.net'
			from "donator@xyz.com"
			subject 'Subject'
			body donation_msg
			add_file "#{Dir.pwd}/tmp/image.png"
		end

		return settings.success
	end
end