#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'X11/Xlib'

class Rendezvous
	include X11

	attr_reader :display

	def self.parse (path)
		new.tap {|r|
			r.instance_eval File.read(path), path, 0
		}
	end

	def initialize (&block)
		@modules = []

		instance_eval &block if block
	end

	def use (klass)
		@modules << klass.new(self)
	end

	def running?
		@running
	end

	def stopped?
		!running?
	end

	def start!
		@running = true

		trap 'INT' do
			stop!
		end

		@display = Display.open

		begin
			display.default_screen.root_window.select_input :SubstructureRedirect
			display.sync!
		rescue Error
			raise 'a window manager is already running'
		end

		display.default_screen.root_window.select_input %w(
			SubstructureRedirect SubstructureNotify StructureNotify
			EnterWindow LeaveWindow ButtonPress PropertyChange
		)

		display.each_event {|event|
			ap event

			throw :skip if stopped?
		}

		quit!
	end

	def stop!
		@running = false
	end

	def quit!
		display.ungrab_key AnyKey, AnyModifier
		display.close

		exit! 0
	end
end
