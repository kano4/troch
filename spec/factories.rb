FactoryGirl.define do
  factory :user, :class => User do
    email 'test@exapmle.com'
    password 'passwd'
  end

  factory :alice, :class => User do
    email 'alice@exapmle.com'
    password 'passwd'
    sites {
      [Factory(:yahoo), Factory(:google)]
    }
  end

  factory :bob, :class => User do
    email 'bob@exapmle.com'
    password 'passwd'
    sites {
      [Factory(:yahoo)]
    }
  end

  factory :site, :class => Site do
    name "Test Site"
    url "http://www.test.com"
    domain_url "test.com"
    ssl_url "https://www.test.com"
  end

  factory :yahoo, :class => Site do
    name "Yahoo!"
    url "http://www.yahoo.com"
  end

  factory :google, :class => Site do
    name "Google"
    url "http://www.google.com"
  end
end
