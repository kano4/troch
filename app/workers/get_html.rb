class GetHtml
  @queue = :default

  def self.perform()
    sleep 3
    path = File.expand_path("log/get_html.log", Rails.root)
    File.open(path, 'a') do |f|
      f.puts "Hello! #{Time.now}"
    end
  end
end
