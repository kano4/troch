if ENV['RAILS_ENV'] != 'test'
  data = YAML.load_file("#{Rails.root}/config/settings.yml")
  s = data["email"]
  s["user_name"]      ||= ""
  s["password"]       ||= ""

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  if s["user_name"].blank? && s["password"].blank?
    ActionMailer::Base.smtp_settings = {
      :address              => s["address"],
      :port                 => s["port"],
      :domain               => s["domain"]
    }
  else
    ActionMailer::Base.smtp_settings = {
      :address              => s["address"],
      :port                 => s["port"],
      :domain               => s["domain"],
      :user_name            => s["user_name"],
      :password             => s["password"],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }
  end
end
