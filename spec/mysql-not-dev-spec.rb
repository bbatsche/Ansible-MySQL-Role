require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/mysql-install.yml", env_name: "production"
  end
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'slow_query_log'\"") do
  its(:stdout) { should match /OFF/ }
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'log_queries_not_using_indexes'\"") do
  its(:stdout) { should match /OFF/ }
end
