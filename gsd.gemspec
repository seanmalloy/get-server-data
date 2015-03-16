Gem::Specification.new do |s|
  s.name                  = 'gsd'
  s.version               = '1.0.0'
  s.date                  = '2015-03-02'
  s.summary               = 'Get Server Data'
  s.description           = 'CLI tool to get server data from various sources'
  s.authors               = ['Sean Malloy']
  s.email                 = 'spinelli85@gmail.com'
  s.files                 = Dir["lib/**/*", "test/**/*", "bin/*"]
  s.executables           << 'gsd'
  s.homepage              = 'https://github.com/seanmalloy/get-server-data'
  s.license               = 'BSD'
  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency 'thor', '~> 0.19.1'
  s.add_runtime_dependency 'net-ping', '~> 1.7.7'
  s.add_development_dependency 'minitest', '~> 5.5.1'
  s.add_development_dependency 'travis-lint', '~> 2.0.0'
  s.add_development_dependency 'bundler', '~> 1.8.4'
  s.add_development_dependency 'coveralls'
end

