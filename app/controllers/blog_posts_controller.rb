class BlogPostsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:generate_epub]
  def generate_epub
    ids = params[:ids].split(",")
    links = []
    if(ids)
      posts = BlogPost.where(:id.in => ids)
      domain = posts.first.blog.name
      links = posts.collect(&:blog_url)
      domain_folder = "public/ebooks/" + domain
      Dir.mkdir domain_folder unless Dir.exists? domain_folder
      Dir.mkdir domain_folder + "/html" unless Dir.exists? domain_folder + "/html"
      HtmlGenerator.new(posts, domain_folder).generate
      EbookBuilder.new(posts).build
      send_file "#{Rails.public_path}/ebooks/#{domain}/site.epub", :filename => "site.epub"
    else
      render :json => false
    end
  end
end
