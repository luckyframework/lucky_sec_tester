# mock the Lucky constants

module Lucky
  class RouteHelper
    record Settings, base_uri : String

    def self.settings
      Settings.new(base_uri: "http://test.app")
    end

    property method : String
    property path : String

    def initialize(@method : String, @path : String)
    end

    def url
      self.class.settings.base_uri + path
    end
  end

  abstract class Action
    macro method(val)
      def self.method : String
        {{ val }}
      end
    end

    macro path(val)
      def self.path : String
        {{ val }}
      end
    end

    def self.route
      Lucky::RouteHelper.new(method: method, path: path)
    end
  end
end
