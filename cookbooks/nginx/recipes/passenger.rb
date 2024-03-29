#
# Cookbook Name:: nginx
# Recipe:: Passenger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.default["nginx"]["passenger"]["version"] = "3.0.19"

if node["languages"].attribute?("ruby")
  node.default["nginx"]["passenger"]["root"] = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
  node.default["nginx"]["passenger"]["ruby"] = node['languages']['ruby']['ruby_bin']
else
  Chef::Log.warn("node['languages']['ruby'] attribute not detected in #{cookbook_name}::#{recipe_name}")
  Chef::Log.warn("Install a Ruby for automatic detection of node['nginx']['passenger'] attributes (root, ruby)")
  Chef::Log.warn("Using default values that may or may not work for this system.")
  node.default["nginx"]["passenger"]["root"] = "/usr/lib/ruby/gems/1.8/gems/passenger-#{node['nginx']['passenger']['version']}"
  node.default["nginx"]["passenger"]["ruby"] = "/usr/bin/ruby"
end

node.default["nginx"]["passenger"]["max_pool_size"] = 10
node.default["nginx"]["passenger"]["spawn_method"] = "smart-lv2"
node.default["nginx"]["passenger"]["use_global_queue"] = "on"
node.default["nginx"]["passenger"]["buffer_response"] = "on"
node.default["nginx"]["passenger"]["max_pool_size"] = 6
node.default["nginx"]["passenger"]["min_instances"] = 1
node.default["nginx"]["passenger"]["max_instances_per_app"] = 0
node.default["nginx"]["passenger"]["pool_idle_time"] = 300
node.default["nginx"]["passenger"]["max_requests"] = 0
node.default["nginx"]["passenger"]["gem_binary"] = nil

packages = value_for_platform( ["redhat", "centos", "scientific", "amazon", "oracle"] => {
                                 "default" => %w(ruby-devel curl-devel) },
                               ["ubuntu", "debian"] => {
                                 "default" => %w(ruby-dev libcurl4-gnutls-dev) } )

packages.each do |devpkg|
  package devpkg
end

gem_package 'rake'

gem_package 'passenger' do
  action :install
  version node["nginx"]["passenger"]["version"]
  gem_binary node["nginx"]["passenger"]["gem_binary"] if node["nginx"]["passenger"]["gem_binary"]
end

template "#{node["nginx"]["dir"]}/conf/passenger.conf" do
  source "modules/passenger.conf.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :passenger_root => node["nginx"]["passenger"]["root"],
    :passenger_ruby => node["nginx"]["passenger"]["ruby"],
    :passenger_max_pool_size => node["nginx"]["passenger"]["max_pool_size"],
    :passenger_spawn_method => node["nginx"]["passenger"]["spawn_method"],
    :passenger_use_global_queue => node["nginx"]["passenger"]["use_global_queue"],
    :passenger_buffer_response => node["nginx"]["passenger"]["buffer_response"],
    :passenger_max_pool_size => node["nginx"]["passenger"]["max_pool_size"],
    :passenger_min_instances => node["nginx"]["passenger"]["min_instances"],
    :passenger_max_instances_per_app => node["nginx"]["passenger"]["max_instances_per_app"],
    :passenger_pool_idle_time => node["nginx"]["passenger"]["pool_idle_time"],
    :passenger_max_requests => node["nginx"]["passenger"]["max_requests"]
  )
  notifies :reload, "service[nginx]"
end

node.run_state['nginx_configure_flags'] =
  node.run_state['nginx_configure_flags'] | ["--add-module=#{node["nginx"]["passenger"]["root"]}/ext/nginx"]
