include_recipe "apt"
package "pkg-config" do
  action :install
end

package "rabbitmq-server" do
  action :install
end