class BlogService
  attr_accessor :blog_type, :url, :category
  def initialize url
    @url = url.scan("http://").empty? ? "http://" + url.downcase : url.downcase
    @domain = nil
    @blog_type = nil
    @category = nil
    detect_blog_type
  end

  def detect_blog_type
    hostname = URI.parse(URI.encode(@url)).host.downcase
    if(hostname.scan(".wordpress.com").any?)
      @blog_type = "wordpress"
      category = @url.scan(/\/category\/(.*)/)[0]
      @category = (category && category[0]) ? category[0].gsub("/", "") : nil
    elsif(hostname.scan(/.blogspot.[com|in]/).any?)
      category = @url.scan(/\/search\/label\/(.*)/)[0]
      @category = (category && category[0]) ? category[0].gsub("/", "") : nil
      @blog_type = "blogspot"
    end
    @domain =  @blog_type ? hostname : nil
  end

  def title_list
    blog = Blog.where(name: @domain).last if @blog_type
    if @blog_type == "wordpress"
      Wordpress.new(blog, @category).posts
    elsif  @blog_type == "blogspot"
      Blogger.new(blog, @category).posts
    end
    HtmlGenerator.new(blog).generate if @blog_type
  end

end
