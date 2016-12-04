class UserShift < ApplicationRecord
  belongs_to :user
  belongs_to :shift

  after_save :notify
  # after_update :notify

  # @@REMINDER_TIME = 30.minutes # minutes before appointment


  def notify
	  @twilio_number = ENV['TWILIO_NUMBER']
	  @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
	  start = ((self.shift.start).localtime).strftime("%I:%M%p on %b. %d, %Y")
	  finish = ((self.shift.end).localtime).strftime("%I:%M%p on %b. %d, %Y")
	  shift = self.shift.id
	  @phone = self.user.phone
	  message = "Hi #{self.user.email}. You have a new shift from #{start} to #{finish}. If for any reason you cannot make it please reply NO #{shift} to this text"
	  message = @client.account.messages.create(
			  :from => @twilio_number,
			  :to => @phone,
			  :body => message,
	  )
		  puts message.to
  end

  # def when_to_run
	 #  time - @@REMINDER_TIME
  # end

  # handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
