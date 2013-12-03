class Users::SessionsController < Devise::SessionsController
	include BeltExtension
	def new
		super
	end

	def create
		super
		update_belt
	end

	def destroy
		return redirect_to root_path, :notice => 'Signed out successfully.'  if current_user.nil?
		old_count = current_user.session_sign_in_count
		new_count =  (Time.now.utc)-(current_user.current_sign_in_at) if (Time.now.utc)-(current_user.current_sign_in_at) >300
		current_user.recent_session_time = new_count
		current_user.session_sign_in_count = new_count.present? ? (old_count + new_count) : old_count
		current_user.session_total_hours = (current_user.session_sign_in_count)/3600
		current_user.average_session_time = (current_user.session_sign_in_count)/current_user.sign_in_count
		super
	end
end