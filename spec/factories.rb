FactoryGirl.define do
  factory :user do
    email 'user@test.com'
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

  factory :site do
    name "Test Site"
    url "http://www.test.com"
    watch_method 'html_body'
    domain_url "test.com"
    domain_expired "2012-02-01"
    ssl_url "https://www.test.com"
    ssl_expired "2012-02-01"
  end

  factory :yahoo, :class => Site do
    name "Yahoo!"
    watch_method 'html_body'
    url "http://www.yahoo.com"
  end

  factory :google, :class => Site do
    name "Google"
    watch_method 'html_body'
    url "http://www.google.com"
  end
end
