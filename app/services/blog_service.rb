class BlogService
  attr_accessor :blog_type
  def initialize url
    @url = url
    @domain = nil
    @blog_type = "wordpress"
    detect_blog_type
  end

  def detect_blog_type
    hostname = URI.parse(URI.encode(@url)).host.downcase
    if(hostname[".wordpress."])
      @blog_type = "wordpress"
    elsif(hostname[".blogger."])
      @blog_type = "blogger"
    end
    @domain = hostname
  end

  def title_list
    if @blog_type == "wordpress"
      blog = Blog.find_or_create_by(name: @domain)
      Wordpress.new(blog).posts
    end
  end

end
