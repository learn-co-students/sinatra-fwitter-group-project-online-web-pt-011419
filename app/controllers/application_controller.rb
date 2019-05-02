require './config/environment'
require "./app/models/user"
require "pry"
class ApplicationController < Sinatra::Base
  enable :sessions
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, "password_security"
  end
  
  get '/' do
   erb :index
  end
  
  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect '/tweets'
    else
      erb :'users/create_user'
    end
  end
  
  post "/signup" do
    user = User.create(:username => params[:username],:email => params[:email], :password => params[:password])
	  if user.save && user.username != "" && user.email !="" && user.authenticate(params[:password])
	      session[:user_id] = user.id
        redirect '/tweets' 
    else
      redirect "/signup"
    end
  end
  
  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect 'tweets/tweets'
    end

    erb :"/users/login"
  end

  post "/login" do
    	user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end
  
  get "/logout" do
   if Helpers.is_logged_in?(session)
    session.clear 
    redirect '/login'
   else 
     redirect '/tweets'
   end
  end
  
   
   get '/tweets/new' do
    if Helpers.is_logged_in?(session)
     erb :'tweets/new'
    else 
      redirect '/login'
    end
   end
   
   
  get '/tweets' do
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @tweets = Tweet.all
    @user = Helpers.current_user(session)
    erb :"/tweets/tweets"
  end
  
  post '/tweets' do 
     user = Helpers.current_user(session)
    if !params[:content].empty? 
     tweet = Tweet.create(:content => params[:content], :user_id => user.id)
      redirect "/tweets"
     else 
       redirect 'tweets/new'
      end
    end
    
      
  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show_tweet'
    else 
      redirect '/login'
    end
  end
  
  get '/tweets/:id/edit' do
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @tweet = Tweet.find(params[:id])
    erb :"tweets/edit_tweet"
  end
    
  
  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if params["content"].empty?
      redirect "/tweets/#{params[:id]}/edit"
    end
    tweet.update(:content => params["content"])
    tweet.save

    redirect to "/tweets/#{tweet.id}"
  end
  
  post '/tweets/:id/delete' do 
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user_id == Helpers.current_user(session).id
      @tweet.delete
    end
    redirect to '/tweets'
  end

  
  get '/users/:slug' do
    slug = params[:slug]
    @user = User.find_by_slug(slug)
    erb :"users/show"
  end
  
 
    
end
