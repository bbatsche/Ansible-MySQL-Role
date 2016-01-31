require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/mysql-install.yml"
  end
end

describe command("mysql --version") do
  its(:stdout) { should match /\b5\.5\.\d+/ }

  its(:exit_status) { should eq 0 }
end

describe command("mysqld --version") do
  its(:stdout) { should match /\b5\.5\.\d+/ }

  its(:exit_status) { should eq 0 }
end

describe service('mysqld') do
  it { should be_running }
end

describe command("mysql -u vagrant -pvagrant -e \"SELECT 'MySQL Installed'\"") do
  its(:stdout) { should match /MySQL Installed/ }

  its(:exit_status) { should eq 0}
end

describe command("mysql -u root") do
  its(:stderr) { should match /Access denied for user 'root'@'localhost'/ }

  its(:exit_status) { should_not eq 0}
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'slow_query_log'\"") do
  its(:stdout) { should match /ON/ }
end

describe command("mysql -u vagrant -pvagrant -e \"SHOW VARIABLES LIKE 'log_queries_not_using_indexes'\"") do
  its(:stdout) { should match /ON/ }
end
