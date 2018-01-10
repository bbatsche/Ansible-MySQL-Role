require "serverspec"

shared_examples "mysql server" do
  describe service('mysql') do
    let(:disable_sudo) { false }

    it { should be_running }
  end
end

shared_examples "mysql client" do |version|
  describe "MySQL Client" do
    let(:subject) { command("mysql --version") }

    it "is installed" do
      expect(subject.stdout).to match /\b#{Regexp.quote(version)}\.\d+/
    end

    include_examples "no errors"
  end
end

shared_examples "mysql security" do
  describe "Default Admin User" do
    let(:subject) { command(%Q{mysql -Nqs -uvagrant -pvagrant -e "SELECT 'MySQL Installed'"}) }

    it "allows admin access to database" do
      expect(subject.stdout).to match /MySQL Installed/

      # Can't use "no errors" since stderr may get a (totally valid) warning about passwords on the command line
      expect(subject.exit_status).to eq 0
    end
  end

  describe "Root User" do
    let(:disable_sudo) { false }
    let(:subject) { command("mysql -uroot") }

    it "does not allow access" do
      expect(subject.stderr).to match /Access denied for user 'root'/

      expect(subject.exit_status).not_to eq 0
    end
  end
end

shared_examples "mysql variable" do |variable, value|
  it "#{variable} is #{value}" do
    output = command(%Q{mysql -Nqs -uvagrant -p#{mysql_password} -e "SHOW VARIABLES LIKE '#{variable}'"}).stdout
    
    subject = output.strip.gsub(/#{Regexp.quote(variable)}\s+(.+)$/, '\1')
    
    expect(subject).to eq value
  end
end
