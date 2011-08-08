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

Site.create(:name => 'Google', :url => 'http://www.google.com/')
Site.create(:name => 'Yahoo', :url => 'http://www.yahoo.co.jp/')
Site.create(:name => 'msn', :url => 'http://jp.msn.com/')
