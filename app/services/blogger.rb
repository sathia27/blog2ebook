require 'open-uri'
class Blogger
  def initialize blog, category=nil
    @blog = blog
    @category = category
  end
  
  def post link
    visit link
    all(:css, ".post-content").to_a
  end

  def posts_rss
    #items(author/displayName,blog,content,customMetaData,id,images,kind,labels,selfLink,title,titleLink,url)
    res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&start-index=1&max-results=500#{(@category ? '&category='+@category : '')}"))
    res_body = JSON.parse(res.body)
    total_post = res_body["feed"]["openSearch$totalResults"]["$t"]
    pages = (1..total_post.to_i).step(500).to_a
    pages.each do |page|
      res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&start-index=#{page}&max-results=500#{(@category ? '&category='+@category : '')}"))
      res_body = JSON.parse(res.body)
      entries = res_body["feed"]["entry"].collect { |entry| [entry["link"].last["href"], entry["author"][0]["name"]["$t"], entry["title"]["$t"]]}
      entries.each do |entry|
        link = entry[0]
        author = entry[1]
        title = entry[2]
        begin
          uri = URI(link)
          page_res = Net::HTTP.get_response(URI("http://#{@blog.name}/feeds/posts/default?alt=json&v=2&dynamicviews=1&path=#{uri.path}"))
          entry = JSON.parse(page_res.body)["feed"]["entry"][0]["content"]
          if(entry)
            description = entry["$t"]
            BlogPost.create( title: title, content: description, author: author, blog_url: link, blog_id: @blog.id )
          end
        rescue => e
          puts e.inspect
        end
      end
    end
    @blog.posts_count = total_post
    @blog.category = @category if @category
    @blog.downloaded = true
    @blog.save
    @blog.reload
    @blog.blog_posts
  end

  def posts
    #via api
    api_key = "AIzaSyDKoS6fA-WtesuAA9wu3tVqMm5TWqDU8fg"
    blog_stat_url = "https://www.googleapis.com/blogger/v3/blogs/byurl?url=#{CGI.escape("http://"+@blog.name)}&key=#{api_key}&maxResults=100"
    puts blog_stat_url
    blog_stat_json_response = Net::HTTP.get_response(URI(blog_stat_url))
    blog_stat_response = JSON.parse(blog_stat_json_response.body)
    blog_id = blog_stat_response["id"]
    puts blog_id
    if(blog_id)
      total_items = blog_stat_response["posts"]["totalItems"]
      @blog.posts_count = total_items
      @blog.save
      page_token=nil
      first_page=true
      loop do
        blog_url = "https://www.googleapis.com/blogger/v3/blogs/#{blog_id}/posts?key=#{api_key}"
        puts blog_url
        if(page_token.present? || first_page)
          puts page_token.inspect
          puts first_page.inspect
          blog_url += "&pageToken=#{page_token}" if page_token.present?
          blog_url += "&labels=#{@category}" if @category.present?
          puts blog_url
          blog_posts_json_response = Net::HTTP.get_response(URI(blog_url))
          blog_posts_response = JSON.parse(blog_posts_json_response.body)
          blog_posts = blog_posts_response["items"]
          page_token = blog_posts_response["nextPageToken"]
          if(blog_posts)
            blog_posts.each do |post|
              description = post["content"]
              link = post["url"]
              title = post["title"]
              author = post["author"]["displayName"]
              BlogPost.create( title: title, content: description, author: author, blog_url: link, blog_id: @blog.id )
            end
          end
        else
          break
        end
        first_page = false
      end
    end
    @blog.downloaded = true
    @blog.category = @category
    @blog.save
    @blog.reload
    @blog.blog_posts
  end
end
