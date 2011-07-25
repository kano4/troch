Factory.define :user, :class => User do |u|
  u.email 'test@exapmle.com'
  u.password 'passwd'
end

Factory.define :alice, :class => User do |u|
  u.email 'alice@exapmle.com'
  u.password 'passwd'
  u.sites {
    [Factory(:yahoo), Factory(:google)]
  }
end

Factory.define :bob, :class => User do |u|
  u.email 'bob@exapmle.com'
  u.password 'passwd'
  u.sites {
    [Factory(:yahoo)]
  }
end

Factory.define :yahoo, :class => Site do |s|
  s.name "Yahoo!"
  s.url "http://www.yahoo.com"
end

Factory.define :google, :class => Site do |s|
  s.name "Google"
  s.url "http://www.google.com"
end
