class BlogWorker
  def blog_request url
    Net::HTTP.get_response(URI.parse(URI.encode(url)))
  end
end
