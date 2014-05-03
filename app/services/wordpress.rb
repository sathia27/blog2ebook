class Wordpress
  def initialize url
    @domain = url
    @url = "https://public-api.wordpress.com/rest/v1/sites/#{url}/posts"
  end

  def title_list
    post_result_from_redis = $redis.get(@domain)
    return JSON.parse(post_result_from_redis) if(post_result_from_redis)
    posts_result = []
    puts @url
    json_page = Net::HTTP.get_response(URI.parse(@url))
    found_count = JSON.parse(json_page.body)["found"]
    if(found_count)
     (1..(found_count/20+1)).each do |page|
        begin
          puts page.to_s
          posts = Net::HTTP.get_response URI.parse(@url+"?page="+page.to_s)
          posts = JSON.parse(posts.body)
          if(posts["posts"])
            posts = posts["posts"].map { |h| h.slice("URL", "title", "content") }
            posts_result += posts
          end
        rescue
          posts_result
        end
      end
    end
    $redis.set(@domain, posts_result.to_json)
    posts_result
  end

  def fetch urls
    post_result_from_redis = $redis.get(@domain)
    if(post_result_from_redis)
      post_results = JSON.parse(post_result_from_redis)
      post_results = post_results.select {|post| urls.include?(post["URL"])}
    end
  end
  
  
end
