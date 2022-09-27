require "spec"
require "./support/*"
require "../src/lucky_sec_tester"

LuckySecTester.configure do |settings|
  settings.bright_token = "test123"
  settings.project_id = "abc123zyx-default"
end
