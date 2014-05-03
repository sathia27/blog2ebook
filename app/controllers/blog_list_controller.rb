class BlogListController < ApplicationController
  def index
  end

  def search
    if params[:url]
      @links = BlogService.new(params[:url]).title_list
    end
    render :layout => false
  end

  def fetch
    @links = nil
    if(params[:links])
      domain, posts = BlogService.new(params[:links][0]).fetch(params[:links])
      domain_folder = "public/ebooks/" + domain
      ebooks_html_folder = "ebooks/" + domain + "/html/"
      Dir.mkdir domain_folder unless Dir.exists? domain_folder
      Dir.mkdir domain_folder + "/html" unless Dir.exists? domain_folder + "/html"
      HtmlGenerator.new(posts, domain_folder).generate
      EbookBuilder.new(posts, domain_folder, ebooks_html_folder, domain).build
    end
    render :json => @links
  end
end
