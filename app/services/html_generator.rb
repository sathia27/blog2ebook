require 'open-uri'
class HtmlGenerator
  def initialize posts
    @posts = posts
    blog = @posts.last.blog
    @domain_folder = "public/ebooks/" + blog.name
  end

  def generate
    i = 1
    blog = @posts.last.blog
    CoverPageGenerator.new(blog).generate
    cover_page
    @posts.each do |post|
      begin
        f = File.open("#{@domain_folder}/html/#{post.id.to_s}.html", "w")
        #Dir.mkdir "#{@domain_folder}/html/images_#{post.id.to_s}" unless Dir.exists? "#{@domain_folder}/html/images_#{post.id.to_s}"
        #img_folder = "#{@domain_folder}/html/images_#{post.id.to_s}"
        post_element = Nokogiri::HTML::DocumentFragment.parse(post.content.strip)
        post_content = post_element.to_xhtml
        # post_element.css("img").each do |img|
        #   begin
        #     image_src = img.attr("src")
        #     j = 1
        #     File.open("#{img_folder}/image#{j}.jpg", 'wb') do |fo|
        #       fo.write open("#{image_src}").read
        #       img.attributes["src"] = "#{img_folder}/image#{j}.jpg"
        #       j += 1
        #     end
        #   rescue => e
        #     puts e
        #   end
        # end
        content =  "<html xmlns='http://www.w3.org/1999/xhtml'><head><title>" + post.title + "</title></head><body><h1>" + post.title + "</h1><div>" + post_content + "</div></body></html>"
        f.write(content)
        f.close
        i += 1
      rescue => e
        puts e
      end
    end
  end

  def cover_page
    blog = @posts.first.blog
    cover_tmpl = File.open("public/ebook_css/cover.txt", "r").read
    cover_content = cover_tmpl.gsub("{{BOOK_NAME}}", blog.book_name).gsub("{{AUTHOR_NAME}}", @posts.first.author).gsub("{{PUBLISHER_NAME}}", blog.publisher).gsub("{{LICENSE_NAME}}", blog.license).gsub("{{LANGUAGE_NAME}}", blog.language)
    cover_page = File.open("#{@domain_folder}/html/file0.html", "w")
    cover_page.write(cover_content)
    cover_page.close
  end

end
