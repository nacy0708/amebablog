#codig: utf-8
require 'base64'
require 'date'
require 'digest'

module Amebablog
  # atomエンドポイント
  ATOM_HOST  = "atomblog.ameba.jp"
  BLOG_PATH  = "/servlet/_atom/blog"
  IMAGE_PATH = "/servlet/_atom/image"
  
  ##
  # アメブロ用ライブラリ基底
  class Base
    attr_reader :username
  
    def initialize(name, pass, translated=false)
      @username = name
      @password = pass
      @pass_translated = translated
    end
    
    
    protected
    # x-wsseヘッダの作成
    def x_wsse
      pass  = @pass_translated ? @password : Digest::MD5.hexdigest(@password).downcase
      now = DateTime::now.strftime("%Y-%m-%dT%H:%M:%SZ")
      nonce = Digest::SHA1.hexdigest(Time.now.to_i.to_s + rand.to_s + now)
      digest = Base64.encode64([Digest::SHA1.hexdigest(nonce + now + pass)].pack("H*")).chomp
      { "X-WSSE" => sprintf(
        %Q<UsernameToken Username="%s", PasswordDigest="%s", Nonce="%s", Created="%s">,
        @username, digest, Base64.encode64(nonce).chomp, now)
      } # x-wsse
    end
    
    # HTTP::GET
    def request_get(path)
      response = Net::HTTP.start(ATOM_HOST) do |http|
        http.get( path, x_wsse )
      end
      response_check response.code
      
      response
    end
    
    # HTTP:POST
    def request_post(path, body)
      response = Net::HTTP.start(ATOM_HOST) do |http|
        http.post( path, body, x_wsse )
      end
      response_check response.code
      
      response
    end
    
    # HTTP::DELETE
    def request_delete(path)
      response = Net::HTTP.start(ATOM_HOST) do |http|
        http.delete( path, x_wsse )
      end
      response_check response.code
      
      response
    end
    
    # HTTP::PUT
    def request_put(path, body)
      response = Net::HTTP.start(ATOM_HOST) do |http|
        http.put( path, body, x_wsse )
      end
      response_check response.code
      
      response
    end
    
    private
    def response_check(code)
      case code
      when "400"
        raise "Bad Request."
      when "401"
        raise "Unauthorized."
      when "403"
        raise "Forbidden."
      when "405"
        raise "Method Not Allowed."
      end
    end
  end
end

