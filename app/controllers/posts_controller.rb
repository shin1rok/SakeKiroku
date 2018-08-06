class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    # タグで絞り込む場合
    if params[:tag_name] && (tag = Tag.find_by(name: params[:tag_name]))
      @posts = []
      flash.now[:tag_flash] = "#{params[:tag_name]}で絞り込み"
      Post.where(user_id: @current_user.id).order(created_at: :desc).each do |post|
        # post_idとtag_idで絞り込んだ時にpost_tagテーブルにレコードが存在する場合、add
        PostTag.where(post_id: post.id, tag_id: tag.id).each do |post_tag|
          if post_tag
            @posts << post
          end
        end
      end
    else
      # タグで絞り込まない場合
      @posts = Post.where(user_id: @current_user.id).order(created_at: :desc)
    end
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
    # render時に値を保持する
    @post.content = params[:content]
    @post_tags = params[:tags]

    # タグが入力されている場合はregister_tagsを呼び出す
    params[:tags] && register_tags(params[:tags])

    # タグに変更があるか確認せずに問答無用でDELETEする場合
    Post.transaction do
      # ポストに紐づくタグを削除
      post_tags = PostTag.where(post_id: @post.id)
      post_tags.destroy_all
      # ポストを更新
      @post.save!
      # ポストに紐づくタグを登録
      params[:tags].split(',').each do |tag|
        tag_id = Tag.find_by(name: tag).id
        post_tag = @post.post_tags.new(tag_id: tag_id)
        post_tag.save!
      end
      flash[:notice] = '投稿を編集しました'
      redirect_to '/posts/index'
    end
    rescue => e
      # :TODO message should change
      flash[:notice] = e.message
      render '/posts/edit'
  end

  def destroy
    @post = Post.find_by(id: params[:post_id],
                         user_id: @current_user.id)
    @post.destroy
    flash[:notice] = '投稿を削除しました'
    redirect_to '/posts/index'
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:post_id])
    if @post.user_id != @current_user.id
      flash[:notice] = '権限がありません'
      redirect_to '/posts/index'
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
