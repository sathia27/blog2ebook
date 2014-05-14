class BlogsController < ApplicationController

  def search
  end

  def posts
    @posts = {}
    if params[:url]
      blog_service = BlogService.new(params[:url])
      blog_hostname = blog_service.detect_blog_type
      category = blog_service.category
      if(category)
        blog = Blog.where(name: blog_hostname, category: category).last
      else
        blog = Blog.where(name: blog_hostname, category: nil).last
      end
      if blog && blog.downloaded
        @posts = blog.blog_posts
      end
    end
  end

  def downloads
    @blogs = Blog.downloaded.desc(:created_at).page(params[:page]).per(10)
  end

  def scrap
    blog_hostname = BlogService.new(params[:url]).detect_blog_type
    if(blog_hostname)
      blog = Blog.create(name: blog_hostname)
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
