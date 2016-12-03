class ShiftsController < ApplicationController
	before_action :authenticate_user!
	def index
		@shifts = Shift.all
	end

	def new
		@shift = Shift.new
	end

	def show
		@shift = Shift.find(params[:id])

	end

	def create
		shift = current_user.shifts.create(shift_params)
		redirect_to shift_path(shift)
	end

	def update

	end

	def destroy
		@shift = Shift.find(params[:id])
		@shift.destroy
		redirect_to root_path
	end
	private

	def shift_params
		params.require(:shift).permit(:date, :start, :end)
	end
end
