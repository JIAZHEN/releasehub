class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      flash.now[:success] = "Profile updated"
    end
    render "edit"
  end

  private

  def user_params
    params.permit(:name, :slack_username)
  end
end
