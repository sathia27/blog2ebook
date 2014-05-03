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
    builder = GEPUB::Builder.new {
      language "ta"
      unique_identifier domain, 'Book', @domain
      title "EBook for #{domain}"
      creator domain
      date Time.now.to_s
      resources(:workdir => "public") {
        file 'ebook_css/default.css'
        ordered {
          j = 1
          posts.each do |post|
            file "#{ebooks_html_folder}/file#{j}.html"
            heading "Chapter #{j.to_s}"
            j += 1
          end
        }
      }
    }
    epubname = "#{@domain_folder}/site.epub"
    builder.generate_epub(epubname)
  end
end
