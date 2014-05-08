require "rmagick"
include Magick
class CoverPageGenerator
  def initialize blog
    @blog = blog
  end

  def generate
    blog_name = @blog.name
    img =  Magick::ImageList.new("public/ebook_css/ebook.jpg")
    canvas = Magick::ImageList.new
    canvas.new_image(450, 700, Magick::TextureFill.new(img))
    text = Magick::Draw.new
    text.font_family = 'helvetica'
    text.pointsize = 40
    text.gravity = Magick::CenterGravity
    text.annotate(canvas, 0,0,2,2, blog_name) {
      self.fill = 'gray83'
    }
    canvas.write('ebook_1.jpg')
  end
end
