
begin
  require "#{dir = File.dirname(__FILE__)}/task/gemgem"
rescue LoadError
  sh 'git submodule update --init'
  exec Gem.ruby, '-S', $PROGRAM_NAME, *ARGV
end

Gemgem.init(dir) do |s|
  s.name    = 'request-replay'
  s.version = '0.5.0'
  %w[bacon rack].each{ |g| s.add_development_dependency(g) }
end
