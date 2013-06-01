include_recipe "apt"

apt_repository "dotdeb" do
  uri "http://packages.dotdeb.org"
  distribution "squeeze"
  components ["all"]
  key "http://www.dotdeb.org/dotdeb.gpg"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

apt_repository "dotdeb-php54" do
  uri "http://packages.dotdeb.org"
  distribution "squeeze-php54"
  components ["all"]
  key "http://www.dotdeb.org/dotdeb.gpg"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

