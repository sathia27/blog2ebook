class HtmlGenerator
  def initialize posts, domain_foder
    @posts = posts
    @domain_folder = domain_foder
  end

  def generate
    i = 1
    @posts.each do |post|
      f = File.open("#{@domain_folder}/html/file#{i}.html", "w")
      content =  "<html xmlns='http://www.w3.org/1999/xhtml'><head></head><body>" + post["content"].strip + "</body></html>"
      f.write(content)
      f.close
      i += 1
    end
  end
end
