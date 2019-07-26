require 'mongoid'
require_relative 'comment'

class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :author, type: String
  field :title, type: String
  field :picture, type: String
  field :description, type: String
  field :likes, type: Integer, default: 0

  embeds_many :comments
end