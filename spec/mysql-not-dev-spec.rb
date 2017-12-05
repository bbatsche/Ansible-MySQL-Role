require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/mysql-install.yml", ENV["TARGET_HOST"], env_name: "production")
  end
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'slow_query_log'\"") do
  its(:stdout) { should match /OFF/ }
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'log_queries_not_using_indexes'\"") do
  its(:stdout) { should match /OFF/ }
end
