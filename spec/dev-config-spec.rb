require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name: "dev",
      install_mysql: true
    })
  end
end

context "MySQL variables" do
  let(:mysql_password) { "vagrant" }
  
  describe "slow query log" do
    include_examples("mysql variable", "slow_query_log", "ON")
  end

  describe "log queries not using indexes" do
    include_examples("mysql variable", "log_queries_not_using_indexes", "ON")
  end
end
