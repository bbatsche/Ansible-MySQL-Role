require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:      "dev",
      install_mysql: true,
      new_db_name:   "test_db",
      new_db_user:   "test_db_owner",
      new_db_pass:   "password123"
    })
  end
end

describe "New database" do
  let(:subject) { command('mysql -Nqs -utest_db_owner -ppassword123 -e "SHOW CREATE DATABASE test_db"') }

  it "should exist" do
    expect(subject.stdout).to match /CREATE DATABASE "|`test_db"|`/
  end

  it "should use utf8mb4" do
    expect(subject.stdout).to match /DEFAULT CHARACTER SET utf8mb4/
  end
end

describe "New DB user" do
  let(:subject) { command(%Q{mysql -Nqs -utest_db_owner -ppassword123 -e "SELECT count(*) FROM mysql.user WHERE User = 'test_db_owner'"}) }

  it "should not be able to query other DBs" do
    expect(subject.stderr).to match /SELECT command denied to user 'test_db_owner'@'localhost'/

    expect(subject.exit_status).not_to eq 0
  end
end
