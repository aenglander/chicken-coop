include_recipe "apt"

package "openjdk-7-jre-headless" do
  action :install
end