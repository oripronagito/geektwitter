class TweetsController < ApplicationController
  before_action :authenticate_user!,except: [:index, :show]
  before_action :correct_user, only:[:edit,:update,:destroy]
    #追加箇所
  def new
    @tweet = Tweet.new
    @tweet = current_user.tweets.new
  end

  def create
    tweet = Tweet.new(tweet_params)

    tweet.user_id = current_user.id

    tag_list = params[:tweet][:tag_name].split(nil)

    if tweet.save!
      tweet.save_tag(tag_list)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def index
    if params[:search] != nil && params[:search] != ''
      search = params[:search]
      @tweets = Tweet.joins(:user).where("tweets.body LIKE ? OR users.name LIKE ?","%#{search}%","%#{search}")
      @tag_list = Tag.all
    else
      @tweets = Tweet.all
      @tag_list = Tag.all
    end
  end

  def show
    @tweet = Tweet.find(params[:id])

    @tags = @tweet.tags
    @comments = @tweet.comments
    @comment = Comment.new
  end
  
  def edit
    @tweet = Tweet.find(params[:id])
    @tag_list = @tweet.tags.pluck(:tag_name).join(nil)
  end

  def update
    tweet = Tweet.find(params[:id])
    if params[:tweet][:tag_name].present?
      tag_list = params[:tweet][:tag_name].split
    else
      tag_list = []
    end
    if tweet.update(tweet_params)
      old_relations = TagMap.where(tweet_id: tweet.id)
      old_relations.each do |relation|
        relation.delete
      end
      tweet.save_tag(tag_list)
      redirect_to :action => "show", :id => tweet.id,notice:'投稿編集完了しました'
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @tweets = @tag.tweets.all
  end

  private
  def tweet_params
    params.require(:tweet).permit(:name, :body, :datetime, :user_id)
  end

  def correct_user
    @tweet = Tweet.find(params[:id])
    redirect_to tweets_path unless @tweet.user == current_user
  end
 #ここまで

end
