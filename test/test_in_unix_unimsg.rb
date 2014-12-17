# vim:fileencoding=utf-8
require 'helper'

class UnixUnimsgInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::UnixUnimsgInput).configure(conf)
  end

  def test_configure_default
    d = create_driver
    assert_equal false, d.instance.use_abstract
    assert_equal "debug.print", d.instance.tag
    assert_equal "data", d.instance.key
    assert_equal "UTF-8", d.instance.in_str_encoding
  end

  def test_configure_set
    d = create_driver(
      %[
        path /foo/bar/a.sock
        use_abstract true
        tag tag.bar
        key content
        in_str_encoding euc-jp
      ])
    assert_equal "/foo/bar/a.sock", d.instance.path
    assert_equal true, d.instance.use_abstract
    assert_equal "tag.bar", d.instance.tag
    assert_equal "content", d.instance.key
    assert_equal "euc-jp", d.instance.in_str_encoding
  end

  def test_record
    cpath = "/test.sock"
    ctag = "foo.bar"
    ckey = "content"

    d = create_driver(%[
                      path #{cpath}
                      use_abstract true
                      tag #{ctag}
                      key #{ckey}
                      ])

    t = Time.parse("2014-10-27 13:25:10 JST").to_i
    Fluent::Engine.now = t

    v = "recorddata"
    d.expect_emit ctag, t, {ckey => v}

    d.run do
      d.expected_emits.each do |tag, time, record|
        c = UNIXSocket.new("\0#{cpath}")
        c.write v
        c.close
      end
    end
  end

  def test_encoding_utf8
    cpath = "/test.sock"
    ctag = "foo.bar"
    ckey = "content"

    d = create_driver(%[
                      path #{cpath}
                      use_abstract true
                      tag #{ctag}
                      key #{ckey}
                      ])

    t = Time.parse("2014-10-27 13:25:10 JST").to_i
    Fluent::Engine.now = t

    v = "日本語".force_encoding('UTF-8')
    d.expect_emit ctag, t, {ckey => v}

    d.run do
      d.expected_emits.each do |tag, time, record|
        c = UNIXSocket.new("\0#{cpath}")
        c.write v
        c.close
      end
    end
  end

  def test_encoding_sjis
    cpath = "/test.sock"
    ctag = "foo.bar"
    ckey = "content"

    d = create_driver(%[
                      path #{cpath}
                      use_abstract true
                      tag #{ctag}
                      key #{ckey}
                      in_str_encoding shift_jis
                      ])

    t = Time.parse("2014-10-27 13:25:10 JST").to_i
    Fluent::Engine.now = t

    v = "日本語".force_encoding('Shift_JIS')
    d.expect_emit ctag, t, {ckey => v}

    d.run do
      d.expected_emits.each do |tag, time, record|
        c = UNIXSocket.new("\0#{cpath}")
        c.write v
        c.close
      end
    end
  end

end

