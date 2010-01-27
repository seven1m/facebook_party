require File.dirname(__FILE__) + '/../lib/facebook_party'
require 'test/unit'
require 'md5'

class FacebookPartyTest < Test::Unit::TestCase

  def setup
    if ENV['FACEBOOK_API_KEY'] and ENV['FACEBOOK_API_SECRET']
      @fb = FacebookParty.new(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_API_SECRET'])
    else
      puts 'Must set FACEBOOK_API_KEY and FACEBOOK_API_SECRET env variables before running.'
      exit(1)
    end
  end

  def test_sig
    assert_equal MD5.hexdigest("arg1=val1arg2=val2#{ENV['FACEBOOK_API_SECRET']}"), @fb.generate_sig({'arg1' => 'val1', 'arg2' => 'val2'})
  end
  
  def test_create_token
    response = @fb.auth.createToken
    assert response['auth_createToken_response']
  end

end
