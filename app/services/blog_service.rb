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
    elsif(hostname.scan(/.blogspot.[com|in]/).any?)
      @blog_type = "blogspot"
    end
    @domain =  @blog_type ? hostname : nil
  end

  def title_list
    blog = Blog.find_or_create_by(name: @domain) if @blog_type
    if @blog_type == "wordpress"
      Wordpress.new(blog).posts
    elsif  @blog_type == "blogspot"
      Blogger.new(blog).posts
    end
    HtmlGenerator.new(blog).generate if @blog_type
  end

end
