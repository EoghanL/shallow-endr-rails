class SessionsController < ApplicationController

  def login
    @user = User.find_by(email: auth_params[:email])
    byebug
    if @user
      if @user.authenticate(auth_params[:password])
        jwt_token = Auth.issue({user_id: @user.id})
        render json: { user_id: @user.id, jwt: jwt_token }
      else
        render json: { errors: "Incorrect Password"}
      end
    else
      render json: { errors: "Unrecognized user" }
    end
  end

private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
