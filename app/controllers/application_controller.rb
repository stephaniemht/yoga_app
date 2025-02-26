class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> {
    (controller_name == 'pages' && action_name == 'home') ||
    (controller_name == 'contacts' && action_name == 'create')
  }

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_dashboard_path # Remplace par la bonne route si nécessaire
  end
end
