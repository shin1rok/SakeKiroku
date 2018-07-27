class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.where(user_id: @current_user.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content],
                     user_id: @current_user.id)
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to "/posts/index"
    else
      render '/posts/new'
    end


  # 入力されたタグがタグテーブルにあるか確認
  # ある場合→何もしない
  # ない場合→タグテーブルにInsert
  #
  # postテーブルとpost_tagテーブルにInsert
  #
  end

  def edit
    @post = Post.find_by(id: params[:post_id])

  # タグがあれば表示する
  #
  end

  def update
    @post = Post.find_by(id: params[:post_id],
                         user_id: @current_user.id)
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to "/posts/index"
    else
      render '/posts/edit'
    end

    # 入力されたタグがタグテーブルにあるか確認
    # ある場合→何もしない
    # ない場合→タグテーブルにInsert
    #
    # postテーブルとpost_tagテーブルを更新する
    #
  end

  def destroy
    @post = Post.find_by(id: params[:post_id],
                         user_id: @current_user.id)
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to "/posts/index"

  # postが削除されるとき、post_tagテーブルも削除する。
  # tagテーブルはそのまま残す
  #
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:post_id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to "/posts/index"
    end
  end
end
