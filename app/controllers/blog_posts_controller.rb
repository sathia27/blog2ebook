class BlogPostsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:generate_epub]
  def generate_epub
    ids = params[:ids].split(",")
    if(ids)
      posts = BlogPost.where(:id.in => ids)
      blog = posts.first.blog
      domain = blog.name
      HtmlGenerator.new(blog).generate
      EbookBuilder.new(posts).build
      send_file "#{Rails.public_path}/ebooks/#{domain}/site.epub", :filename => "#{blog.book_name.gsub(" ", "_")}.epub"
    else
      render :json => false
    end
  end
end
