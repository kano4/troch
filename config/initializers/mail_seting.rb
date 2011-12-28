data = YAML.load_file("#{Rails.root}/config/email.yml")
s = data["settings"]
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address              => s["address"],
  :port                 => s["port"],
  :domain               => s["domain"]
}
