class BlogService
  attr_accessor :blog_type, :url
  def initialize url
    @url = url.scan("http://").empty? ? "http://" + url.downcase : url.downcase
    @domain = nil
    @blog_type = nil
    detect_blog_type
  end

  def detect_blog_type
    hostname = URI.parse(URI.encode(@url)).host.downcase
    if(hostname.scan(".wordpress.com").any?)
      @blog_type = "wordpress"
    #elsif(hostname.scan(".blogger.com").any?)
      #@blog_type = "blogger"
    end
    @domain =  @blog_type ? hostname : nil
  end

  def title_list
    if @blog_type == "wordpress"
      blog = Blog.find_or_create_by(name: @domain)
      Wordpress.new(blog).posts
      HtmlGenerator.new(blog).generate
    end
  end

end
