# encoding: utf-8
class EbookBuilder
  def initialize posts, domain_folder, ebooks_html_folder, domain
    @posts = posts
    @domain_folder = domain_folder
    @ebooks_html_folder = ebooks_html_folder
    @domain = domain
  end

  def build
    posts = @posts
    ebooks_html_folder = @ebooks_html_folder
    domain = @domain
    domain_folder = @domain_folder
    builder = GEPUB::Builder.new {
      unique_identifier domain, 'Book', domain
      title "EBook for #{domain}"
      creator domain
      date Time.now.to_s
      resources(:workdir => "public") {
        file 'ebook_css/default.css'
        file 'ebook_css/ebook.jpg'
        ordered {
          j = 1
          file "#{ebooks_html_folder}/file0.html"
          posts.each do |post|
            file "#{ebooks_html_folder}/file#{j}.html"
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
