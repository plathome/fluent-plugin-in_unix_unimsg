# Fluent::Plugin::InUnixUnimsg

Processing a uni message via Unix Domain Socket

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-in_unix_unimsg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-in_unix_unimsg

## Test

```
$ [bundle exec] rake test
```

## Usage

```
<source>
  type unix_unimsg
  path /path/a.sock
  tag debug.pp
  key data
  use_abstract true
</source>

$ echo "Content" | socat - abstract-connect:/path/a.sock
=> debug.pp | {"data": "Content"}
```

EOT

