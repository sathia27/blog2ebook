# encoding: utf-8
class EbookBuilder
  def initialize posts
    @posts = posts
  end

  def build
    posts = @posts
    blog = @posts.last.blog
    domain_folder = "public/ebooks/" + blog.name
    ebooks_html_folder = "ebooks/" + blog.name + "/html"
    domain = blog.name
    builder = GEPUB::Builder.new {
      unique_identifier domain, 'Book', domain
      title "EBook for #{domain}"
      creator domain
      date Time.now.to_s
      resources(:workdir => "public") {
        file 'ebook_css/default.css'
        cover_image "#{ebooks_html_folder}/ebook.jpg"
        ordered {
          j = 1
          file "#{ebooks_html_folder}/file0.html"
          posts.each do |post|
            file "#{ebooks_html_folder}/#{post.id.to_s}.html"
            Dir.glob("#{post.id.to_s}/*.jpg") { |f| file f }
            heading post["title"]
            j += 1
          end
        }
      }
    }
    epubname = "#{domain_folder}/site.epub"
    builder.generate_epub(epubname)
  end

end
