require "RMagick"
class CoverPageGenerator
  def initialize blog
    @blog = blog
  end

  def generate
    return false if(@blog.blog_posts.count == 0)
    img =  Magick::ImageList.new("public/ebook_css/ebook.jpg")
    canvas = Magick::ImageList.new
    canvas.new_image(450, 700, Magick::TextureFill.new(img))
    text = Magick::Draw.new
    text.font = "public/ta.ttf"
    text.gravity = Magick::CenterGravity
    text.annotate(canvas, 450,300,0,0, @blog.book_name) {
      self.fill = '#fff'
      self.encoding = "UTF-8"
      self.pointsize = 30
    }
    text.annotate(canvas, 450,400,0,0, "Publisher: #{@blog.publisher}") {
      self.fill = '#fff'
      self.pointsize = 20
    }
    text.annotate(canvas, 450,450,0,0, "Author: #{@blog.blog_posts.first.author}") {
      self.fill = '#fff'
      self.pointsize = 20
    }
    text.annotate(canvas, 450,500,0,0, "License: #{@blog.license}") {
      self.fill = '#fff'
      self.pointsize = 20
    }
    text.annotate(canvas, 450,550,0,0, "Language: #{@blog.language}") {
      self.fill = '#fff'
      self.pointsize = 20
    }
    text.annotate(canvas, 450,1300,0,0, "Ebook is dynamically created by blog2ebook app.") {
      self.fill = '#fff'
      self.pointsize = 15
    }
    text.annotate(canvas, 450,1350,0,0, " Source code: https://github.com/sathia27/blog2ebook") {
      self.fill = '#fff'
      self.pointsize = 15
    }
    canvas.write("public/ebooks/#{@blog.name}/html/ebook.jpg")
  end
end
