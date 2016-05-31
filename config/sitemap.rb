# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://the-tournament.jp"
SitemapGenerator::Sitemap.public_path = 'tmp/sitemaps'


SitemapGenerator::Sitemap.create do
  add '/about'
  add '/gift'
  add '/terms'
  add '/privacy'

  Tournament.find_each do |tournament|
    add "/tournaments/#{tournament.id}/#{tournament.encoded_title}", lastmod: tournament.updated_at
    add "/tournaments/#{tournament.id}/players"
    add "/tournaments/#{tournament.id}/games"
  end

  Category.find_each do |category|
    add "/tournaments?tag=#{category.tag_name}"
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
