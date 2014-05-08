class BlogPost
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :content, type: String
  field :categories, type: Array
  field :blog_url, type: String
  field :author
  index({ blog_url: 1 }, { name: "blog_url_index" })

  belongs_to :blog, index: true
end
