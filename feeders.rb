require 'dm-core'
require 'dm-migrations'

class Feeders
	include DataMapper::Resource
	property :id, Serial
	property :email, String
	property :name, String
	property :phone, String
	property :state, String
	property :address, Text
	# property :pincode, String
	property :times_fed, Integer

	# validations
	# validates_uniqueness_of :email

end

# To re-initialize the DB, uncomment this line. Need to have the adapter
# to run DataMapper.auto_migrate!
# DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/feeders.db")

DataMapper.finalize
