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
  field :category
  index({ name: 1 }, { name: "name_index" })
  
  scope :downloaded, ->{ where(:downloaded => true ) }

  has_many :blog_posts
end
