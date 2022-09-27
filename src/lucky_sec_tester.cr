require "habitat"
require "sec_tester"

class LuckySecTester
  VERSION = "0.1.0"

  Habitat.create do
    setting bright_token : String, example: "abc.nexp.123secret"
    setting project_id : String, example: "ufNQ7Fo4XAFBsuyGpo6YTz"
  end

  getter client : SecTester::Test do
    SecTester::Test.new(settings.bright_token)
  end

  delegate :run_check, :cleanup, to: client

  def build_target
    SecTester::Target.new(Lucky::RouteHelper.settings.base_uri)
  end

  def build_target(action : Lucky::Action.class, *, headers : HTTP::Headers = HTTP::Headers.new)
    build_target(action.route, headers: headers) { |target| target }
  end

  def build_target(action : Lucky::Action.class, *, headers : HTTP::Headers = HTTP::Headers.new)
    build_target(action.route, headers: headers) do |target|
      yield target
    end
  end

  def build_target(route : Lucky::RouteHelper, *, headers : HTTP::Headers = HTTP::Headers.new)
    build_target(route, headers: headers) { |target| target }
  end

  def build_target(route : Lucky::RouteHelper, *, headers : HTTP::Headers = HTTP::Headers.new)
    target = SecTester::Target.new(
      method: route.method.to_s,
      url: route.url,
      headers: default_headers_for_method(route.method.to_s).merge!(headers)
    )
    yield target
    target
  end

  private def default_headers_for_method(method : String) : HTTP::Headers
    content_type = if method.downcase == "get"
                     "text/html"
                   else
                     "application/x-www-form-urlencoded"
                   end

    HTTP::Headers{
      "Content-Type" => content_type,
      "Host"         => URI.parse(Lucky::RouteHelper.settings.base_uri).hostname.to_s,
    }
  end
end
