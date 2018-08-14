class UsersController < ApplicationController

  def destroy
    posts = Post.where(user_id: @current_user.id)
    user = User.find_by(id: @current_user.id)
    User.transaction do
      posts.each(&:destroy)
      user.destroy
      flash[:notice] = '退会しました'
      redirect_to '/'
    end
    rescue => e
    flash[:notice] = e.message
    redirect_to '/posts/index'
  end
end
