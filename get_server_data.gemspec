Gem::Specification.new do |s|
  s.name                  = 'get_server_data'
  s.version               = '1.0.0'
  s.date                  = '2015-11-15'
  s.summary               = 'Get Server Data'
  s.description           = 'CLI tool to get server data from various sources'
  s.authors               = ['Sean Malloy']
  s.email                 = 'spinelli85@gmail.com'
  s.files                 = Dir["lib/**/*", "test/**/*", "bin/*"]
  s.executables           << 'gsd'
  s.homepage              = 'https://github.com/seanmalloy/get-server-data'
  s.license               = 'BSD'
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency 'net-ping', '~> 1.7'
  s.add_runtime_dependency 'table_print', '~> 1.5'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'coveralls', '~> 0.8'
  s.add_development_dependency 'minitest', '~> 5.5'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'travis-lint', '~> 2.0'
  s.add_development_dependency 'yard', '~> 0.9.11'
end

