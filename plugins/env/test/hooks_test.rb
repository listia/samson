require_relative 'test_helper'

describe "env hooks" do
  let(:deploy) { deploys(:succeeded_test) }
  let(:stage) { deploy.stage }

  describe :after_deploy_setup do
    around { |test| Dir.mktmpdir { |dir| Dir.chdir(dir) { test.call } } }

    before { stage.env = "HELLO=world\nWORLD=hello" }

    it "writes env to .env" do
      Samson::Hooks.fire(:after_deploy_setup, Dir.pwd, stage)
      File.read(".env").must_equal "HELLO=world\nWORLD=hello"
    end

    it "merges env into ENV.json" do
      File.write("ENV.json", JSON.dump("env" => {"HELLO" => 1, "OTHER" => 1}, "other" => true))
      Samson::Hooks.fire(:after_deploy_setup, Dir.pwd, stage)
      File.read("ENV.json").must_equal "{
  \"env\": {
    \"HELLO\": \"world\",
    \"OTHER\": 1,
    \"WORLD\": \"hello\"
  },
  \"other\": true
}"
    end

    it "does not write env to .env when env is empty" do
      stage.env = ""
      Samson::Hooks.fire(:after_deploy_setup, Dir.pwd, stage)
      File.exist?(".env").must_equal false
    end
  end
end
