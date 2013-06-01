service "php5-fpm" do
  supports :status => true, :restart => true, :reload => true
end

cookbook_file "php-fpm-pool-coupla" do
  source "php/fpm/pool/coupla.conf"
  mode "0644"
  path "/etc/php5/fpm/pool.d/coupla.conf"
  notifies :reload, "service[php5-fpm]", :delayed
end

cookbook_file "nginx-site-coupla" do
  source "nginx/sites/coupla"
  mode "0644"
  path "/etc/nginx/sites-available/coupla"
end

execute "nginx-site-coupla-enable" do
  command "ngxensite coupla"
  notifies :reload, "service[nginx]", :delayed
  not_if do
    File.exists?("/etc/nginx/sites-enbled/coupla")
  end
end

execute "nginx-site-default-disable" do
  command "ngxdissite default"
  notifies :reload, "service[nginx]", :delayed
  only_if do
    File.exists?("/etc/nginx/sites-enbled/default")
  end
end
