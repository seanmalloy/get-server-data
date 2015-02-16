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
end

