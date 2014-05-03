class BlogListController < ApplicationController
  def index
  end

  def search
    if params[:url]
      @links = BlogService.new(params[:url]).title_list
    end
    render :layout => false
  end

  def fetch
    @links = nil
    if(params[:links])
      domain, links = BlogService.new(params[:links][0]).fetch(params[:links])
      Dir.mkdir "public/" + domain unless Dir.exists? "public/" + domain
      i = 1
      links.each do |link|
        f = File.open("public/"+domain+"/file#{i}.html", "w")
        content =  "<html><head></head><body>" + link["content"].strip + "</body></html>"
        f.write(content)
        f.close
        i += 1
      end
      builder = GEPUB::Builder.new {
        language 'en'
        unique_identifier domain, 'BookID', domain
        title 'GEPUB Sample Book'
        subtitle 'This book is just a sample'

        creator 'KOJIMA Satoshi'

        contributors 'Denshobu', 'Asagaya Densho', 'Shonan Densho Teidan', 'eMagazine Torutaru'

        date '2012-02-29T00:00:00Z'

        resources(:workdir => "public/#{domain}/") {
          ordered {
            j = 1
            links.each do |link|
              file "file#{j}.html"
              heading link["title"]
              j += 1
            end
          }
        }
      }
      epubname = "public/#{domain}/site.epub"
      puts epubname.inspect
      builder.generate_epub(epubname).inspect
    end
    render :json => @links
  end
end
