require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:                      "dev",
      install_mysql:                 true,
      mysql_mem_percent:             80,
      innodb_buffer_pool_percent:    60,
      innodb_buffer_pool_chunk_size: "1M",
      mysql_key_buffer_percent:      20,
      mysql_enable_network:          true,
      mysql_sql_mode:                "TRADITIONAL"
    })
  end
end

context "MySQL variables" do
  let(:mysql_password) { "vagrant" }
  let(:totalMem) { host_inventory["memory"]["total"].to_i }

  describe "InnoDB buffer pool size" do
    let(:subject) { command(%Q{mysql -Nqs -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size'"}) }

    it "is set based on total memory" do
      expect(subject.stdout.gsub(/innodb_buffer_pool_size\s+(.+)$/, '\1').to_i / 1024).to be_within(5120).of((totalMem * 0.8 * 0.6).to_i)
    end
  end

  describe "Key buffer size" do
    let(:subject) { command(%Q{mysql -Nqs -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'key_buffer_size'"}) }

    it "is set based on total memory" do
      expect(subject.stdout.gsub(/key_buffer_size\s+(.+)$/, '\1').to_i / 1024).to be_within(5120).of((totalMem * 0.8 * 0.2).to_i)
    end
  end

  describe "SQL mode" do
    let(:subject) { command(%Q{mysql -Nqs -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'sql_mode'"}) }

    it "is set in config" do
      expect(subject.stdout.gsub(/sql_mode\s+(.+)$/, '\1')).not_to match /REAL_AS_FLOAT/
      expect(subject.stdout.gsub(/sql_mode\s+(.+)$/, '\1')).not_to match /PIPES_AS_CONCAT/
      expect(subject.stdout.gsub(/sql_mode\s+(.+)$/, '\1')).not_to match /ANSI_QUOTES/

      expect(subject.stdout.gsub(/sql_mode\s+(.+)$/, '\1')).to match /STRICT_TRANS_TABLES/
      expect(subject.stdout.gsub(/sql_mode\s+(.+)$/, '\1')).to match /STRICT_ALL_TABLES/
    end
  end

  describe "bind address" do
    include_examples("mysql variable", "bind_address", "*")
  end
end
