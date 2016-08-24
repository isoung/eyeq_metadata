Gem::Specification.new do |spec|
  spec.name          = 'eyeq_metadata'
  spec.version       = '1.3.4'
  spec.authors       = ['Isaiah Soung']
  spec.date          = '2016-08-03'
  spec.summary       = 'HTTP client used specifically to request metadata from Gracenote EyeQ'
  spec.description   = 'Request Gracenote EyeQ metadata using the eyeq api'
  spec.homepage      = 'https://github.com/Isoung/eyeq_metadata'
  spec.license       = 'MIT'
  spec.files         = [
    'lib/eyeq_metadata.rb',
    'README.md'
  ]
  spec.add_runtime_dependency 'httpi', '>= 2.4.2'
  spec.add_development_dependency 'rubocop', '>= 0.41.1'
  spec.add_development_dependency 'rspec', '>= 3.5.0'
  spec.add_development_dependency 'webmock', '>= 2.1.0'
end
