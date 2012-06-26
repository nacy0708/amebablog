# coding: utf-8

module Amebablog
  class Feed
    MATCH_OFFSET = /offset=(\d{1,})/
    attr_reader :next_url, :prev_url, :blog_url, :blog_title, :username, :entries
    
    def initialize(feed)
      xml = Nokogiri::HTML::DocumentFragment.parse(feed)
      @blog_title = xml.css('feed > title').text
      @username   = xml.css('feed > author > name').text
      @blog_url   = xml.css('feed > link[rel="alternate"]').first[:href]
      unless (url = xml.css('feed > link[rel="next"]').first).nil?
        @next_url   = url[:href].text
      end
      unless (url = xml.css('feed > link[rel="prev"]').first).nil?
        @prev_url   = url[:href].text
      end
      
      # entry
      @entries = []
      xml.css('feed > entry').each do |entry|
        @entries << Amebablog::Entry.new(entry)
      end
    end
    
    
    
    def next_offset
      return if @next_url.nil?
      
      @next_url =~ MATCH_OFFSET
      $1 || 0 # offset=0 で開始点から
    end
    
    def prev_offset
      return if @prev_url.nil?
      
      @prev_url =~ MATCH_OFFSET
      $1 || 0 # offset=0 で開始点から
    end
  end
end

