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
    blog = Blog.find_or_create_by(name: blog_hostname)
    if !blog.processing and !blog.downloaded
      BlogService.new(params[:url]).delay.title_list
      blog.processing = true
      blog.save
    end
    render :json => blog.to_json
  end

  def downloaded
    blog_hostname = BlogService.new(params[:url]).detect_blog_type
    blog = Blog.where(name: blog_hostname).last
    render :json => {status: (blog && blog.downloaded ? true : false)}.to_json
  end
end
