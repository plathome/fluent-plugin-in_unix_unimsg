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
  path /foo/bar/a.sock
  use_abstract true    # default false
  tag good.tag          # default debug.print
  key content          # default data
</source>

$ echo "Content" | socat - unix-connect:/foo/bar/a.sock
=> good.tag | {"data": "Content"}
```

EOT

