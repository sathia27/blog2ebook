class HtmlGenerator
  def initialize posts, domain_foder
    @posts = posts
    @domain_folder = domain_foder
  end

  def generate
    i = 1
    cover_page
    @posts.each do |post|
      f = File.open("#{@domain_folder}/html/file#{i}.html", "w")
      post_content = Nokogiri::HTML::DocumentFragment.parse(post.content.strip).to_xhtml
      #post_content = Sanitize.clean(post.content.strip, Sanitize::Config::RELAXED)
      content =  "<html xmlns='http://www.w3.org/1999/xhtml'><head><title>" + post.title + "</title><link rel='stylesheet' href='../../../ebook_css/default.css' /></head><body><h1>" + post.title + "</h1><div>" + post_content + "</div></body></html>"
      f.write(content)
      f.close
      i += 1
    end
  end

  def cover_page
    blog = @posts.first.blog
    cover_tmpl = File.open("public/ebook_css/cover.txt", "r").read
    cover_content = cover_tmpl.gsub("{{BOOK_NAME}}", blog.book_name).gsub("{{AUTHOR_NAME}}", @posts.first.author).gsub("{{PUBLISHER_NAME}}", blog.publisher).gsub("{{LICENSE_NAME}}", blog.license).gsub("{{LANGUAGE_NAME}}", blog.language).gsub("{{COVER_IMAGE}}", "/ebook_css/ebook.jpg")
    cover_page = File.open("#{@domain_folder}/html/file0.html", "w")
    cover_page.write(cover_content)
    cover_page.close
  end
end
