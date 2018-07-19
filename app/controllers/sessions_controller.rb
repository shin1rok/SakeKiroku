class SessionsController < ApplicationController
  def login
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if user
      # request.env['omniauth.auth']に、OmniAuthによってHashのようにユーザーのデータが格納されている。
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました'
      redirect_to '/posts/index'
    else
      flash[:notice] = 'ログインできませんでした'
      redirect_to '/posts/index'
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'ログアウトしました'
    redirect_to '/posts/index'
  end
end
