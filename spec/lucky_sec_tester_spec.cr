require "./spec_helper"

class IndexAction < Lucky::Action
  method "get"
  path "/test"
end

class CreateAction < Lucky::Action
  method "post"
  path "/make"
end

describe LuckySecTester do
  # https://github.com/NeuraLegion/sec_tester

  it "overrides the default target header" do
    scanner = LuckySecTester.new
    target = scanner.build_target(IndexAction)
    target.headers["Content-Type"].should eq("text/html")

    target = scanner.build_target(CreateAction)
    target.headers["Content-Type"].should eq("application/x-www-form-urlencoded")

    target = scanner.build_target(IndexAction, headers: HTTP::Headers{"Content-Type" => "application/json"})
    target.headers["Content-Type"].should eq("application/json")

    target = scanner.build_target(CreateAction, headers: HTTP::Headers{"Content-Type" => "application/json"})
    target.headers["Content-Type"].should eq("application/json")
  end
end
