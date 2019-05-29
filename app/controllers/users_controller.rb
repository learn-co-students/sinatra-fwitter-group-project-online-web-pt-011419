class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/tweets'
    end
  end

  post '/signup' do
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      if @user.save
       session[:user_id] = @user.id
       redirect to '/tweets'
     else
       redirect to '/signup'
     end
   end

   get '/login' do
     if !logged_in?
       erb :'/users/login'
     else
       redirect "/tweets"
     end
   end

   post '/login' do
     login(params[:username], params[:password])
     redirect '/tweets'
   end

   get '/logout' do
       logout!
       redirect '/login'
     end

     get '/users/:slug' do
         @user = User.find_by_slug(params[:slug])
         @tweets = @user.tweets.order("id desc")
         erb :"users/show"
       end



end
