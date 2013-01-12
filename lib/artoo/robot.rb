module Artoo
	class Robot
		include Celluloid
		attr_reader :connections, :devices

		def initialize
			initialize_connections
			initialize_devices
		end
		
		class << self
			attr_accessor :connection_types
			attr_accessor :device_types
		end

		# connection to some hardware that has one or more devices via some specific protocol
		# Example:
		# 	connection :arduino, :protocol => :firmata, :port => '/dev/tty.usbmodemxxxxx'
		def self.connection(name, params = {})
			#puts "Registering connection #{name.to_s}..."
			self.connection_types ||= []
			self.connection_types << {:name => name}.merge(params)
		end

		# device that uses a connection to communicate
		# Example:
		# 	device :collision_detect, :driver => :switch, :pin => 3
		def self.device(name, params = {})
			#puts "Registering device #{name.to_s}..."
			self.device_types ||= []
			self.device_types << {:name => name}.merge(params)
		end

		# the work that needs to be performed
		def self.work
			puts "Working..."
		end

		def default_connection
			connections.first
		end

		def connection_types
			self.class.connection_types
		end

		def device_types
			self.class.device_types
		end

		private

		def initialize_connections
			@connections = []
			connection_types.each {|c|
				#puts "Initializing connection #{c[:name].to_s}..."
				@connections << Connection.new(c.merge(:parent => Actor.current))
			}
		end

		def initialize_devices
			@devices = []
			device_types.each {|d|
				#puts "Initializing device #{d[:name].to_s}..."
				@devices << Device.new(d.merge(:parent => Actor.current))
			}
		end
	end
end