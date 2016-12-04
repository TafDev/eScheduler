class ShiftsController < ApplicationController
	before_action :authenticate_user!, except: [:reply]
	skip_before_filter :verify_authenticity_token, only: [:reply]

	def reply
		message_body = params["Body"].downcase
		from_number = params["From"]
		boot_twilio
		if message_body.include?("no")
			shift_id = message_body.scan(/\d+/)
			shift = shift_id[0].to_i
			user = User.find_by(phone: from_number)
			change_shift = user.shifts.find_by(id: shift)
			change_shift.is_reschedulable = true
			change_shift.save
			destroy_shift = user.user_shifts.where(shift_id: shift)
			destroy_shift[0].destroy
			sms = @client.messages.create(
					from: ENV["TWILIO_NUMBER"],
					to: from_number,
					body: "We have received your message, your shift has successfully been cancelled"
			)
		elsif message_body.include?("yes")
			shift_id = message_body.scan(/\d+/)
			shift = shift_id[0].to_i
			user = User.find_by(phone: from_number)
			change_shift = Shift.find_by(id: shift)
			if change_shift.is_reschedulable?
				change_shift.users << user
				change_shift.is_reschedulable = false
				change_shift.save
			else
				sms = @client.messages.create(
						from: ENV["TWILIO_NUMBER"],
						to: from_number,
						body: "The shift has already been taken"
				)
			end
		else
	    sms = @client.messages.create(
			    from: ENV["TWILIO_NUMBER"],
			    to: from_number,
			    body: "Sorry your response was invalid. If you were trying to cancel a shift, please call you line manager for assistance "
	    )
		end


	end

	def index
		@shifts = Shift.all
	end


	def new
		@shift = Shift.new
	end

	def edit
		@shift = Shift.find(params[:id])
	end

	def show
		@shift = Shift.find(params[:id])
		# @members = User.all
	end

	def create
		shift = Shift.create(shift_params)
		redirect_to shift_path(shift)
	end

	def update
		@shift = Shift.find(params[:id])
		@shift.update(shift_params)
	end

	def destroy
		@shift = Shift.find(params[:id])
		@shift.destroy
		redirect_to root_path
	end


	private

	def boot_twilio
		@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
	end

	def shift_params
		params.require(:shift).permit(:date, :start, :end, user_ids: [])
	end
end
