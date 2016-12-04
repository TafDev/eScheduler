class Shift < ApplicationRecord
	has_many :user_shifts
	has_many :users, through: :user_shifts

	after_save :broadcast

	def broadcast
		if self.is_reschedulable?
			@twilio_number = ENV['TWILIO_NUMBER']
			@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
			@users_numbers = User.all
			shift = self.id
			@users_numbers.each do |user|
				@message = "Hi #{user.email}. A new shift has become available. Reply yes #{shift} if you would like to take this shift"
				unless user.phone.nil?
					message = @client.account.messages.create(
							:from => @twilio_number,
							:to => user.phone,
							:body => @message,
					)
					puts message.to
				end
			end
		end
	end
end
