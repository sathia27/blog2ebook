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

  def downloaded
    blog_hostname = BlogService.new(params[:url]).detect_blog_type
    blog = Blog.where(name: blog_hostname).last
    BlogService.new(params[:url]).delay.title_list unless blog
    render :json => {status: (blog && blog.downloaded ? true : false)}.to_json
  end
end
