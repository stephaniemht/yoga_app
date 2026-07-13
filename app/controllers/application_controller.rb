class ApplicationController < ActionController::Base
  before_action :redirect_to_canonical_host
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

  private

  def redirect_to_canonical_host
    return unless Rails.env.production?
    return unless request.get? || request.head?
    return unless request.host == "www.luniversdessens.com"

    redirect_to "https://luniversdessens.com#{request.fullpath}",
                status: :moved_permanently,
                allow_other_host: true
  end
end
