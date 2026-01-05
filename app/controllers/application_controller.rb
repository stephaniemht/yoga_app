class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> {
    (controller_name == 'pages' && action_name == 'home') ||
    (controller_name == 'contacts' && action_name == 'create')
  }

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (resource.admin? ? admin_dashboard_path : super)
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
