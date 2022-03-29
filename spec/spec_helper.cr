require "spec"
require "./support/*"
require "../src/lucky_sec_tester"

LuckySecTester.configure do |settings|
  settings.nexploit_token = "test123"
end
