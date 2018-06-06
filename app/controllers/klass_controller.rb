require 'sinatra/flash'

class KlassController < ApplicationController

	get '/klasses' do
		login_validate
		@user = current_user
		@klasses = Klass.select {|klass| klass.user_id == @user.id || klass.user_id == nil}
		erb :'/klasses/klasses'
	end

	get '/klasses/new' do
		login_validate
		erb :'/klasses/new'
	end

	post '/klasses' do
		login_validate
		@klass = current_user.klasses.create(params[:klass])
		if !@klass.valid?
			flash[:notice] = "Please Fill Out All Forms"
			redirect '/klasses/new'
		else
			flash[:notice] = "Class Created"
			redirect "/klasses/#{@klass.slug}"
		end
	end

	get '/klasses/:slug' do
		login_validate
		@klass = Klass.find_by_slug(params[:slug])
		erb :'/klasses/show'
	end

	get '/klasses/:slug/edit' do
		login_validate
		@klass = Klass.find_by_slug(params[:slug])
		@klasses = Klass.all
		erb :'/klasses/edit'
	end

	patch '/klasses/:slug' do
		login_validate
		@klass = Klass.find_by_slug(params[:slug])
		@klass.update(params[:klass])
		@klass.save
		flash[:notice] = "Class Updated"
		redirect "/klasses/#{@klass.slug}"
	end

	delete '/klasses/:slug/delete' do
		@klass = Klass.find_by_slug(params[:slug])
		if logged_in? && @klass.user_id == session[:id]
			@klass.delete
			flash[:notice] = "Class Deleted"
			redirect '/'
		else
			redirect '/login'
		end
	end

end