class Api::V1::UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!, only: %i[create]

  # POST /api/v1/users
  def create
    user = User.new(email: user_params[:email], password: user_params[:password])
    client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])

    if client_app.nil?
      render json: { error: 'invalid_client'}, status: :unauthorized
    elsif user.save
      access_token = Doorkeeper::AccessToken.create(resource_owner_id: user.id, application_id: client_app.id,
                                                    refresh_token: generate_refresh_token,
                                                    expires_in: Doorkeeper.configuration.access_token_expires_in.to_i)

      render json: { access_token: access_token.token, token_type: 'Bearer', expires_in: access_token.expires_in,
                     refresh_token: access_token.refresh_token, created_at: access_token.created_at.to_time.to_i },
             status: :created
    else
      render json: user.errors, status: 422
    end
  end

  private

    def user_params
      params.permit(:client_id, :email, :password)
    end

    def generate_refresh_token
      SecureRandom.urlsafe_base64(32, false)
    end
end
