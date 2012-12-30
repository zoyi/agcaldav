require 'net/https'
require 'uuid'
require 'rexml/document'
require 'rexml/xpath'
require 'icalendar'
require 'time'
require 'date'

['client.rb', 'request.rb', 'net.rb', 'query.rb', 'filter.rb', 'format.rb'].each do |f|
    require File.join( File.dirname(__FILE__), 'agcaldav', f )
end

class Event
    attr_accessor :uid, :created, :dtstart, :dtend, :lastmodified, :summary, :description, :name, :action, :to_ical
end

class Todo
    attr_accessor :uid, :created, :summary, :dtstart, :status, :completed
end