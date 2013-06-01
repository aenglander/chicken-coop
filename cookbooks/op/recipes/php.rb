include_recipe "apt"

package "make" do
  action :install
end

php_pear "mongo" do
  action :install
end

package "git" do
  action :install
end

if platform_family?("rhel")
  bin_dir = "/usr/bin"
else
  bin_dir = "/usr/local/bin"
end

remote_file "composer" do
  action :create_if_missing
  source "http://getcomposer.org/composer.phar"
  mode "0777"
  path bin_dir + "/composer"
end

cookbook_file "php-config-timezone" do
  source "php/conf.d/timezone.ini"
  mode "0644"
  path "/etc/php5/conf.d/timezone.ini"
  notifies :reload, "service[php5-fpm]", :delayed
end

cookbook_file "php-config-short-tags" do
  source "php/conf.d/short-tags.ini"
  mode "0644"
  path "/etc/php5/conf.d/short-tags.ini"
  notifies :reload, "service[php5-fpm]", :delayed
end

cookbook_file "php-config-xdebug-extra" do
  source "php/conf.d/xdebug-extra.ini"
  mode "0644"
  path "/etc/php5/conf.d/xdebug-extra.ini"
  notifies :reload, "service[php5-fpm]", :delayed
end
