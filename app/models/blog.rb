class Blog
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :processing, type: Mongoid::Boolean, default: false
  field :downloaded, type: Mongoid::Boolean, default: false
  field :posts_count, type: Integer
  field :error_found, type: Mongoid::Boolean, default: false
  field :publisher
  field :license
  field :book_name
  field :language
  index({ name: 1 }, { unique: true, name: "name_index" })
  
  has_many :blog_posts
end
