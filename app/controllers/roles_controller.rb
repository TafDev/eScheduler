class RolesController < ApplicationController
	def index
		@roles = Role.all
	end
	def new
		@role = Role.new
	end

	def show
		@role = Role.find(params[:id])
	end

	def create
		role = Role.create!(role_params)
		redirect_to role_path(role)
	end

	private

	def role_params
		params.require(:role).permit(:name)
	end
end
