require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:      "production",
      install_mysql: true,
      db_pass:       "Secure123!"
    })
  end
end

context "MySQL variables" do
  let(:mysql_password) { "Secure123!" }
  
  describe "slow query log" do
    include_examples("mysql variable", "slow_query_log", "OFF")
  end

  describe "log queries not using indexes" do
    include_examples("mysql variable", "log_queries_not_using_indexes", "OFF")
  end
end

describe "MySQL plugins" do
  let(:mysql_password) { "Secure123!" }
  
  let(:subject) { command(%Q{mysql -Nqs -uvagrant -p#{mysql_password} -e "SHOW PLUGINS"}) }

  it "includes password validation" do
    expect(subject.stdout).to match /validate_password\s+ACTIVE/

    # Can't use "no errors" since stderr may get a (totally valid) warning about passwords on the command line
    expect(subject.exit_status).to eq 0
  end
end
