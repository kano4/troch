set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

every 15.minute do
  runner "Site.get_html"
end

every 1.day, :at => '8:00 am' do
  runner "Site.check_domain"
end
