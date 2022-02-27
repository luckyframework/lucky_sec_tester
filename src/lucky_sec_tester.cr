require "habitat"
require "sec_tester"

class LuckySecTester
  VERSION = "0.1.0"

  Habitat.create do
    setting nexploit_token : String, example: "abc.nexp.123secret"
  end

  getter client : SecTester::Test

  delegate :run_check, :cleanup, to: @client

  def initialize
    @client = SecTester::Test.new(settings.nexploit_token)
  end

  def build_target
    SecTester::Target.new(Lucky::RouteHelper.settings.base_uri)
  end

  def build_target(action : Lucky::Action.class)
    build_target(action.route) { |target| target }
  end

  def build_target(action : Lucky::Action.class)
    build_target(action.route) do |target|
      yield target
    end
  end

  def build_target(route : Lucky::RouteHelper)
    build_target(route) { |target| target }
  end

  def build_target(route : Lucky::RouteHelper)
    target = SecTester::Target.new(
      method: route.method.to_s.upcase,
      url: route.url,
      headers: HTTP::Headers{
        "Content-Type" => "application/x-www-form-urlencoded",
        "Host"         => Lucky::RouteHelper.settings.base_uri,
      }
    )
    yield target
    target
  end
end
