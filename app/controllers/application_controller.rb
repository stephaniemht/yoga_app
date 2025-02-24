class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> { controller_name == 'pages' && action_name == 'home' }
end
