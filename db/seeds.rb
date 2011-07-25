User.create(
  :email => 'test@example.com',
  :password => '123456',
  :password_confirmation => '123456'
)
10.times {
  pass = Forgery::Basic.password
  User.create(
    :email => Forgery::Internet.email_address,
    :password => pass,
    :password_confirmation => pass
  )
}

Site.create(
  :name => 'Example Site',
  :url => 'http://example.com'
)
10.times {
  Site.create(
    :name => Forgery::Name.full_name,
    :url  => 'http://' + Forgery::Internet.domain_name
  )
}
