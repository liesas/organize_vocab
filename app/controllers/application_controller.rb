class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
    def not_found
      render status: :not_found
    end

    def current_user
      @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) unless doorkeeper_token.nil?
    end
end
