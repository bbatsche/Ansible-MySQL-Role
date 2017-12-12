require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {install_mysql: true})
  end
end

describe "MySQL" do
  include_examples "mysql server"
  include_examples("mysql client", "5.7")
end

describe "User Access" do
  include_examples "mysql security"
end

# describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'slow_query_log'\"") do
#   its(:stdout) { should match /ON/ }
# end
#
# describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'log_queries_not_using_indexes'\"") do
#   its(:stdout) { should match /ON/ }
# end
