class MicropostsController < ApplicationController
	before_action :signed_in_user, 			only: [:create, :destroy]
	before_action :admin_or_correct_user, 	only: :destroy

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		micropost_user_url = user_url(@micropost.user)
		@micropost.destroy
		redirect_to micropost_user_url
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def admin_or_correct_user
			if current_user.admin?
				@micropost = Micropost.find_by(id: params[:id])
			else
				@micropost = current_user.microposts.find_by(id: params[:id])
			end
			redirect_to root_url if @micropost.nil?
		end
end