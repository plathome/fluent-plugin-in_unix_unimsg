# coding: utf-8
module Fluent
  class UniMsgHandler < StreamInput::Handler
    def initialize(io, opts, on_message)
      @tag = opts[:tag]
      @key = opts[:key]
      super io, opts[:log], on_message
    end

    def on_connect
      @buf = ""
    end

    def on_read(data)
      @buf << data
    end

    def on_close
      @on_message.call([@tag, 0, {@key => @buf}])
    end
  end

  class UnixUnimsgInput < StreamInput
    Plugin.register_input('unix_unimsg', self)

    config_param :path, :string, :default => DEFAULT_SOCKET_PATH
    config_param :backlog, :integer, :default => nil
    config_param :tag, :string, :default => "debug.print"
    config_param :key, :string, :default => "data"
    config_param :use_abstract, :bool, :default => false

    def configure(conf)
      super
    end

    def listen
      log_line = "listening fluent socket on #{@path}"
      @path = if use_abstract
                log_line << " using abstract"
                sprintf("\0%s", @path)
              else
                File.unlink(@path) if File.exist?(@path)
                FileUtils.mkdir_p File.dirname(@path)
                @path
              end
      log.debug log_line
      s = Coolio::UNIXServer.new(@path, UniMsgHandler, {log: @log, tag: @tag, key: @key}, method(:on_message))
      s.listen(@backlog) unless @backlog.nil?
      s
    end
  end
end

