class BlogsController < ApplicationController

  def search
  end

  def posts
    @posts = {}
    if params[:url]
      blog_hostname = BlogService.new(params[:url]).detect_blog_type
      blog = Blog.where(name: blog_hostname).first
      if blog && blog.downloaded
        @posts = blog.blog_posts
      end
    end
  end

  def scrap
    blog_hostname = BlogService.new(params[:url]).detect_blog_type
    if(blog_hostname)
      blog = Blog.find_or_create_by(name: blog_hostname)
      blog.update_attributes(blog_update)
      if !blog.processing and !blog.downloaded
        BlogService.new(params[:url]).delay.title_list
        blog.processing = true
        blog.save
      end
    end
    render :json => (blog_hostname ? blog.to_json : {error: true}).to_json
  end

  def downloaded
    blog_hostname = BlogService.new(params[:url]).detect_blog_type
    blog = Blog.where(name: blog_hostname).last
    render :json => {status: (blog && blog.downloaded ? true : false)}.to_json
  end

  private
  
  def blog_update
    params.require(:blog).permit(:publisher, :license, :language, :book_name)
  end
end
