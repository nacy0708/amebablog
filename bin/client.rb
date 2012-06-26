# coding: utf-8
require 'net/http'

module Amebablog
  
  class Client < Amebablog::Base
    def initialize(name, pass, translated=false)
      super(name, pass, translated)
      res = request_get(Amebablog::BLOG_PATH)
      
      # user_id(にあたるであろう値)取得
      if res.body =~ /<link(?:.+?)rel=\"service.post\"(?:.+?)href=\"(.+?)\"(?:.+?)\/>/
        @user_id = File.basename($1)
      end
    end
    
    
    ##
    # 投稿した記事一覧の取得
    # ※一度に20件固定
    def get_feed(offset=0)
      res = request_get("#{Amebablog::BLOG_PATH}/#{@user_id}")
      Amebablog::Feed.new(res.body)
    end
    
    ##
    # 指定した記事の取得
    def get_entry(entry_id)
      res = request_get("#{Amebablog::BLOG_PATH}/#{@user_id}/#{entry_id}")
      xml = Nokogiri::HTML::DocumentFragment.parse(res.body)
      Amebablog::Entry.new(xml.css("entry").first)
    end
    
    ##
    # 指定した記事の削除
    def delete_entry(entry_id)
      request_delete("#{Amebablog::BLOG_PATH}/#{@user_id}/#{entry_id}")
    end
    
    ##
    # 指定した記事の編集
    def edit_entry(entry_id, title, content)
      body = <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<entry xmlns="http://purl.org/atom/ns#" xmlns:app="http://www.w3.org/2007/app#" xmlns:mt="http://www.movabletype.org/atom/ns#">
<title>#{title}</title>
<content type="application/xhtml+xml">
<![CDATA[
#{content}
]]>
</content>
<update></update>
</entry>
      EOF
      
      request_put("#{Amebablog::BLOG_PATH}/#{@user_id}/#{entry_id}", body)
    end
    
    ##
    # 記事の投稿
    def post_feed(title, content)
      body = <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<entry xmlns="http://purl.org/atom/ns#" xmlns:app="http://www.w3.org/2007/app#" xmlns:mt="http://www.movabletype.org/atom/ns#">
<title>#{title}</title>
<content type="application/xhtml+xml">
<![CDATA[
#{content}
]]>
</content>
<update></update>
</entry>
      EOF
      
      request_post("#{Amebablog::BLOG_PATH}/#{@user_id}", body)
    end
  end
end
