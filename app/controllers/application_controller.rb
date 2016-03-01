class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # After_sign_in_path is a function that comes with Devise which allows you
  # to set a custom path after the sign in.
  def after_sign_in_path(resource)
  	# Find user contact information which is stored in OrgContact by finding the
  	# user id or in other words the org_person_id (Which we retrieve through) the
  	# login process and store it in local var has_contact_info
  	has_contact_info = OrgContact.find_by(org_person_id: current_org_person.id)
  	# If the person contact info is NOT nil, then we want to check if this person
  	# has a return to page. This basically is return the user back to the original page
  	# that forced him to sign in in the first place. Else it forces the user
  	# to the edit page of his info
  	if !has_contact_info.nil?
  	  if !session[:return_to].nil?
  	  	session[:return_to]
  	  	session.delete[:return_to]
  	  else
  	  	edit_org_person_path(current_org_person.id)
  	  end
  	else
  	  edit_org_person_path(current_org_person.id)
  	end
  end

  # To permit new custom attributes to be verified as attributes permitted by the form
  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation) }
  end
end
