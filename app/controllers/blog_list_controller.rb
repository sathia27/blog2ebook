class BlogsController < ApplicationController

  def search
  end

  def posts
    if params[:url]
      blog_hostname = BlogService.new(params[:url]).detect_blog_type
      blog = Blog.where(name: blog_hostname).first
      if blog && blog.downloaded
        @posts = blog.blog_posts if blog
      else
        BlogService.new(params[:url]).delay.title_list
      end
    end
  end


end
