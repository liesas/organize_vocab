class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
    def not_found
      render status: :not_found
    end
end
