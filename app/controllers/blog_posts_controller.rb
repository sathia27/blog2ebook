class BlogPostsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:generate_epub]
  def generate_epub
    ids = params[:ids].split(",")
    if(ids)
      posts = BlogPost.where(:id.in => ids)
      blog = posts.first.blog
      domain = blog.name
      domain_folder = "public/ebooks/" + domain
      Dir.mkdir domain_folder unless Dir.exists? domain_folder
      Dir.mkdir domain_folder + "/html" unless Dir.exists? domain_folder + "/html"
      EbookBuilder.new(posts).build
      send_file "#{Rails.public_path}/ebooks/#{domain}/site.epub", :filename => "#{blog.book_name.gsub(" ", "_")}.epub"
    else
      render :json => false
    end
  end
end
