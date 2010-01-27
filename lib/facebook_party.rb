require 'httparty'
require 'md5'
require 'uri'

class FacebookParty

  ENDPOINT = 'http://api.facebook.com/restserver.php'
  API_VERSION = '1.0'
  LOGIN_URL = 'http://www.facebook.com/login.php'
  LOGIN_SUCCESS_URL = 'http://www.facebook.com/connect/login_success.html'
  LOGIN_CANCEL_URL = 'http://www.facebook.com/connect/login_failure.html'

  include HTTParty
  format :xml
  
  attr_accessor :token

  # Create a new FacebookParty instance.
  # Pass in the api key and api secret for your app assigned by Facebook.
  # The <tt>method</tt> argument is used internally -- don't pass anything into this argument.
  def initialize(api_key, secret, method=nil)
    @api_key = api_key
    @secret = secret
    @method = method
  end
  
  # Call any api method directly on the instance, e.g.:
  #     fb = FacebookParty.new(API_KEY, SECRET)
  #     response = fb.auth.createToken
  def method_missing(method_name, args={}, test=nil)
    if @method
      args = self.class.stringify_hash_keys(args)
      args.merge!('method' => @method + '.' + method_name.to_s, 'api_key' => @api_key, 'v' => API_VERSION)
      args.merge!('sig' => generate_sig(args))
      self.class.post(ENDPOINT, :body => args)
    else
      self.class.new(@api_key, @secret, method_name.to_s)
    end
  end
  
  # Build an authentication/authorization url for Facebook Connect apps
  # (typically used for Desktop apps)
  # See http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications
  # <tt>req_params</tt> one or more options from list http://wiki.developers.facebook.com/index.php/Extended_permissions
  def auth_url(options={})
    options = {
      'api_key'          => @api_key,
      'fbconnect'        => true,
      'v'                => API_VERSION,
      'connect_display'  => 'page',
      'return_session'   => true,
      'session_key_only' => true,
      'next'             => LOGIN_SUCCESS_URL,
      'cancel_url'       => LOGIN_CANCEL_URL,
      'req_perms'        => ['read_stream', 'publish_stream', 'offline_access'],
    }.merge(self.class.stringify_hash_keys(options))
    options['req_perms'] = options['req_perms'].join(',')
    args = options.map { |k, v| "#{k}=#{URI.escape(v.to_s)}" }.join('&')
    "#{LOGIN_URL}?#{args}"
  end
  
  # Generate the MD5 signature from passed in hash of arguments
  def generate_sig(args)
    MD5.hexdigest(args.sort.map { |k, v| "#{k}=#{v}" }.join + @secret)
  end
  
  def self.stringify_hash_keys(hash) #:nodoc:
    hash.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end
  
end
