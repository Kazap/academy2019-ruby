require 'mongoid'

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :author, type: String
  field :content, type: String
  embedded_in :post
end