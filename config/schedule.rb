require 'fileutils'

set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

begin
  file = File.open("tmp/intervals/cron.dat", "r")
rescue
  FileUtils.mkdir_p("tmp/intervals")
  file = File.open("tmp/intervals/cron.dat", "w")
  file.write(15)
  file.close
  cron_interval = 15
else
  cron_interval = file.gets.to_i
  file.close
end

if cron_interval > 0
  every 15.minute do
    runner "Site.get_html"
  end

  every 1.day, :at => '8:00 am' do
    runner "Site.check_domain"
  end

  every 1.day, :at => '8:00 am' do
    runner "Site.check_ssl"
  end
end
