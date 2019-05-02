class TweetsController < ApplicationController
   
   get '/tweets/new' do
     erb :new
   end
   
   get '/tweets' do 
     erb :'tweets/tweets'
   end

end
