class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.where(user_id: @current_user.id)
  end

  def new
    @post = Post.new
    @post_tags = nil
  end

  def create
    # render時に値を保持する
    @post = Post.new(content: params[:content],
                     user_id: @current_user.id)
    @post_tags = params[:tags]
    # タグが入力されている場合はregister_tagsを呼び出す
    params[:tags] && register_tags(params[:tags])

    # postテーブルとpost_tagテーブルにInsert
    Post.transaction do
      @post.save!
      params[:tags].split(',').each do |tag|
        tag_id = Tag.find_by(name: tag).id
        post_tag = @post.post_tags.new(tag_id: tag_id)
        post_tag.save!
      end
      flash[:notice] = '投稿しました'
      redirect_to '/posts/index'
    end
    rescue => e
      # :TODO message should change
      flash[:notice] = e.message
      render '/posts/new'
  end

  def edit
    @post = Post.find_by(id: params[:post_id])
    post_tags = PostTag.where(post_id: @post.id)
    tags = []
    post_tags.each do |post_tag|
      tags << Tag.find_by(id: post_tag.tag_id).name
    end
    @post_tags = tags.join(',')
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
    # [:tags].split(',').each do |tag|
    #   if Tag.find_by(name: tag)
    #
    #   else
    #     tag = Tag.new(name: tag)
    #     tag.save
    #   end
    # end
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

  def register_tags(tags)
    tags.split(',').each do |tag|
      unless Tag.find_by(name: tag)
        # ない場合は登録
        tag = Tag.new(name: tag)
        unless tag.save
          render '/posts/new' && return
        end
      end
    end
  end
end
