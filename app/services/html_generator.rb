class HtmlGenerator
  def initialize posts, domain_foder
    @posts = posts
    @domain_folder = domain_foder
  end

  def generate
    i = 1
    @posts.each do |post|
      f = File.open("#{@domain_folder}/html/file#{i}.html", "w")
      post_content = Nokogiri::HTML::DocumentFragment.parse(post.content.strip).to_xhtml
      #post_content = Sanitize.clean(post.content.strip, Sanitize::Config::RELAXED)
      content =  "<html xmlns='http://www.w3.org/1999/xhtml'><head><title>" + post.title + "</title></head><body><h1>" + post.title + "</h1><div>" + post_content + "</div></body></html>"
      f.write(content)
      f.close
      i += 1
    end
  end
end
