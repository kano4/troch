set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

every 15.minute do
  runner "Site.get_html"
end
