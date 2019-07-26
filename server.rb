require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'mongoid'
require 'json'

require_relative 'models/post'

Mongoid.load! "mongoid.yml"

set :bind, '0.0.0.0'

before do
  if request.body.size > 0
    request.body.rewind
    @payload = JSON.parse(request.body.read)
  else
    @payload = {}
  end
end

get '/posts' do
  json Post.order_by(updated_at: :desc).as_json(except: :comments)
end

get '/posts/:id' do
  json Post.find(params[:id]).as_json(except: :comments)
end

post '/posts' do
  resource = Post.create(@payload)
  json resource.as_json(except: :comments)
end

patch '/posts/:id' do
  resource = Post.find params[:id]
  resource.update_attributes(@payload)
  json resource.as_json(except: :comments)
end

delete '/posts/:id' do
  resource = Post.find params[:id]
  resource.destroy
  status 204
end

# Comentários

get '/posts/:post_id/comments' do
  parent = Post.find params[:post_id]
  json parent.comments.order_by(created_at: :asc)
end

post '/posts/:post_id/comments' do
  parent = Post.find params[:post_id]
  comment = parent.comments.create(@payload)
  json comment
end

delete '/posts/:post_id/comments/:id' do
  parent = Post.find params[:post_id]
  comment = parent.comments.find(params[:id])
  comment.destroy
  status 204
end