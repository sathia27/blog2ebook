require 'open-uri'
class Blogger
  def initialize blog
    @blog = blog
  end
  
  def post link
    visit link
    all(:css, ".post-content").to_a
  end

  def posts
    res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&start-index=1&max-results=500"))
    res_body = JSON.parse(res.body)
    total_post = res_body["feed"]["openSearch$totalResults"]["$t"]
    pages = (1..total_post.to_i).step(500).to_a
    pages.each do |page|
      res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&start-index=#{page}&max-results=500"))
      res_body = JSON.parse(res.body)
      entries = res_body["feed"]["entry"].collect { |entry| [entry["link"].last["href"], entry["author"][0]["name"]["$t"], entry["title"]["$t"]]}
      entries.each do |entry|
        link = entry[0]
        author = entry[1]
        title = entry[2]
        begin
          uri = URI(link)
          page_res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&v=2&dynamicviews=1&path=#{uri.path}"))
          puts "http://#{@blog.name}/feeds/posts/default?alt=json&v=2&dynamicviews=1&path=#{uri.path}"
          entry = JSON.parse(page_res.body)["feed"]["entry"][0]["content"]
          if(entry)
            description = entry["$t"]
            blog_post = BlogPost.find_or_create_by(blog_url: link)
            blog_post.update_attributes({ title: title, content: description, blog_id: @blog.id.to_s, author: author  })
          end
        rescue => e
          puts e.inspect
        end
      end
    end
    @blog.posts_count = total_post
    @blog.downloaded = true
    @blog.save
    @blog.reload
    @blog.blog_posts
  end
end
