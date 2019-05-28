class TweetsController < ApplicationController



  get '/tweets' do
      if logged_in?
        @tweets = Tweet.all
        erb :'tweets/tweets'
      else
        redirect to '/login'
      end
    end




  get '/tweets/new' do
    if !logged_in?
      redirect '/login'
    else
      erb :'/tweets/new'
    end
  end


  post '/tweets' do
      @tweet = Tweet.new(content: params[:tweet][:content])
      @tweet.user = current_user
      if @tweet.save
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/tweets/new"
      end
    end




  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end


  get '/tweets/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
      @tweet = Tweet.find(params[:id])
      if @tweet.user == current_user
        erb :'tweets/edit_tweet'
      else
        redirect "/tweets"
      end
    end
  end


  patch '/tweets/:id' do
      @tweet = Tweet.find(params[:id])
      @tweet.update(content: params[:tweet][:content])
      if @tweet.save
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end
    end


    post '/tweets/:id/delete' do
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
