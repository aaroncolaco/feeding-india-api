require './feeders'

(10..20).each do |x|
	feeder = Feeders.new
	
	feeder.email = x.to_s + '@gmail.com'
	feeder.pass = 'password'
	feeder.name = 'John Doe'
	feeder.phone = rand(999) + 8000000000
	feeder.state = 'The Shire, Middle Earth'
	feeder.address = 'Bag End,end of Bagshot Row, Hobbiton'
	feeder.times_fed = rand(20)
	
	feeder.save

	# Feeders.last.destroy
end