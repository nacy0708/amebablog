#coding: utf-8
require 'date'

module Amebablog
  class Entry
    attr_reader :id, :title, :modified, :issued, :body
    
    # Nokogiri#Nodeでentryが来ることを想定
    def initialize(entry)
      @id       = File.basename(entry.css("id").text)
      @title    = entry.css("title").text
      @modified = DateTime.strptime( entry.css("modified").text, "%Y-%m-%dT%H:%M:%SZ" )
      @issued   = DateTime.strptime( entry.css("issued").text, "%Y-%m-%dT%H:%M:%SZ" )
      @body     = entry.css("content").text
    end
  end
end

