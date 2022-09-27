# lucky_sec_tester

LuckySecTester is a thin wrapper around the [Bright SecTester](https://github.com/NeuraLegion/sec-tester-cr) used to ensure a smooth Lucky integration.

Use this in your specs and CI to test security vulnerabilities.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   development_dependencies:
     lucky_sec_tester:
       github: luckyframework/lucky_sec_tester
   ```

2. Run `shards install`

3. Install the [Nexploit CLI](https://www.npmjs.com/package/@neuralegion/nexploit-cli) tool

`npm install -g @neuralegion/nexploit-cli`

## Usage

Create a new file in `spec/setup/sec_tester.cr`

```crystal
# spec/setup/sec_tester.cr
require "lucky_sec_tester"

LuckySecTester.configure do |settings|
  # This is your API key
  settings.bright_token = ENV["BRIGHT_TOKEN"]
  # Your project ID which could be environment based, or for app specific
  # if your company has many projects
  settings.project_id = LuckyEnv.staging? "staging-id123" : "default-id123"
end
```

Next, you'll create your spec directory for all of your security tests.
Since these tests will make external API calls, we can use a compiler flag
to optionally enable them.

```crystal
# spec/security_flows/security_spec.cr
{% skip_file unless flag?(:test_security) %}

require "../spec_helper"

describe "Security Testing" do
  # TODO: ...
end

private def scanner
  LuckySecTester.new
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/luckyframework/lucky_sec_tester/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer
