
require 'socket'
require 'stringio'

class RequestReplay
  autoload :Middleware, 'request-replay/middleware'

  NEWLINE      = "\r\n"
  HTTP_VERSION = 'HTTP/1.1'
  RACK_INPUT   = 'rack.input'

  def initialize env, host, options={}
    @env, (@host, @port), @options = env, host.split(':', 2), options
    if env[RACK_INPUT]
      env[RACK_INPUT].rewind
      @buf = StringIO.new
      IO.copy_stream(env[RACK_INPUT], @buf)
      @buf.rewind
    end
  end

  def add_headers
    @options[:add_headers] || {}
  end

  def read_wait
    @options[:read_wait] && Float(@options[:read_wait])
  end

  def start
    write_request
    write_headers
    write_payload
    sock.close_write
    IO.select([sock], [], [], read_wait) if read_wait
    yield(sock) if block_given?
  rescue => e
    @env['rack.errors'].puts("[#{self.class.name}] Error: #{e.inspect}") if
      @env['rack.errors']
  ensure
    sock.close
  end

  def write_request
    sock.write("#{request}#{NEWLINE}")
  end

  def write_headers
    sock.write("#{headers}#{NEWLINE}#{NEWLINE}")
  end

  def write_payload
    return unless @buf
    IO.copy_stream(@buf, sock)
  end

  def request
    "#{@env['REQUEST_METHOD'] || 'GET'} #{request_path} #{HTTP_VERSION}"
  end

  def headers
    headers_hash.map{ |name, value| "#{name}: #{value}" }.join(NEWLINE)
  end

  def request_path
    "/#{@env['PATH_INFO']}?#{@env['QUERY_STRING']}".
      sub(%r{^//}, '/').sub(/\?$/, '')
  end

  def headers_hash
    @headers_hash ||=
      @env.inject({}){ |r, (k, v)|
        r[capitalize_headers(k[5..-1])] = v if k.start_with?('HTTP_')
        r
      }.merge('Content-Type'   => @env['CONTENT_TYPE'  ],
              'Content-Length' => @env['CONTENT_LENGTH']).
        merge(add_headers).select{ |_, v| v }
  end

  def capitalize_headers header
    header.downcase.gsub(/[a-z]+/){ |s| s.capitalize }.tr('_', '-')
  end

  def sock
    @sock ||= TCPSocket.new(@host, Integer(@port || 80))
  end
end
