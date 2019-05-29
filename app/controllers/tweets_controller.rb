class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      @user = current_user
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      redirect to '/login'
  end
end

post '/tweets' do
    @tweet = Tweet.new(content: params[:content])
    @tweet.user = current_user
    if @tweet.save
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/new"
    end
  end

  get '/tweets/:id' do
    if !logged_in?
      redirect "/login"
    else
      @tweet = Tweet.find(params[:id])
      @user = @tweet.user
      erb :"/tweets/show_tweet"
    end
  end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
      @tweet = Tweet.find(params[:id])
      if @tweet.user = current_user
        @user = current_user
        erb :"/tweets/edit_tweet"
      else
        redirect "/tweets"
      end
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])
    @tweet.content = params[:content]
    if @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    if !logged_in?
      redirect "/login"
    else
      @tweet = Tweet.find(params[:id])
      if @tweet.user != current_user
        redirect "/tweets"
      else
        @tweet.delete
        redirect "/tweets"
      end
    end
  end


end
