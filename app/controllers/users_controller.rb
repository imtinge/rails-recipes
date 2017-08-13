class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def show

  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = '修改成功'
      redirect_to edit_user_path
    else
      render 'edit'
    end
  end

  protected

  def user_params
    params.require(:user).permit(:time_zone, :profile_attributs => 
                                [:id, :legal_name, :birthday, :localtion, :education, :occupation, :bio, :specialty])
  end

  def find_user
    @user = current_user
    @user.create_profile unless @user.profile
  end

end
