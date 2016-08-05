Gem::Specification.new do |spec|
  spec.name          = 'eyeq-metadata'
  spec.version       = '1.0.0'
  spec.authors       = ['Isaiah Soung']
  spec.date          = '2016-08-03'
  spec.summary       = 'HTTP client used specifically to request metadata from Gracenote EyeQ'
  spec.description   = 'Request Gracenote EyeQ metadata using the eyeq api'
  spec.homepage      = 'https://github.com/Isoung/eyeq-metadata'
  spec.license       = 'MIT'
  spec.files         = [
    'lib/eyeq_metadata.rb',
    'README.md'
  ]
  spec.required_ruby_version = '>= 2.0.0'
  spec.add_runtime_dependency 'rest-client', '~>2.0.0'
  spec.add_development_dependency 'rubocop', '~>0.41.1'
  spec.add_development_dependency 'rspec', '~>3.5.0'
  spec.add_development_dependency 'webmock', '~>2.1.0'
end
