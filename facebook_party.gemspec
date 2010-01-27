Gem::Specification.new do |s|
  s.name = "facebook_party"
  s.version = "0.1.0"
  s.author = "Tim Morgan"
  s.email = "tim@timmorgan.org"
  s.homepage = "http://github.com/seven1m/facebook_party"
  s.summary = "Lightweight wrapper for Facebook API using HTTParty"
  s.files = %w(README.rdoc lib/facebook_party.rb test/facebook_party_test.rb)
  s.require_path = "lib"
  s.has_rdoc = true
  s.add_dependency("httparty")
end
