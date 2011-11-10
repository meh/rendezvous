Gem::Specification.new {|s|
    s.name         = 'rendezvous'
    s.version      = '0.0.1a1'
    s.author       = 'meh.'
    s.email        = 'meh@paranoici.org'
    s.homepage     = 'http://github.com/meh/rendezvous'
    s.platform     = Gem::Platform::RUBY
    s.summary      = 'The rendezvous of window managers'
    s.files        = Dir.glob('lib/**/*.rb')
    s.require_path = 'lib'
    s.executables  = ['rendezvous']
}
