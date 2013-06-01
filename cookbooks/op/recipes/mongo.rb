include_recipe "apt"

apt_repository "mongo-10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

package "mongodb-10gen" do
  action :install
end