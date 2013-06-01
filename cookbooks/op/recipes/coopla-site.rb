service "php5-fpm" do
  supports :status => true, :restart => true, :reload => true
end

cookbook_file "php-fpm-pool-coopla" do
  source "php/fpm/pool/coopla.conf"
  mode "0644"
  path "/etc/php5/fpm/pool.d/coopla.conf"
  notifies :reload, "service[php5-fpm]", :delayed
end

cookbook_file "nginx-site-coopla" do
  source "nginx/sites/coopla"
  mode "0644"
  path "/etc/nginx/sites-available/coopla"
end

execute "nginx-site-coupla-enable" do
  command "ngxensite coupla"
  notifies :reload, "service[nginx]", :delayed
  not_if do
    File.exists?("/etc/nginx/sites-enbled/coopla")
  end
end

execute "nginx-site-default-disable" do
  command "ngxdissite default"
  notifies :reload, "service[nginx]", :delayed
  only_if do
    File.exists?("/etc/nginx/sites-enbled/default")
  end
end
