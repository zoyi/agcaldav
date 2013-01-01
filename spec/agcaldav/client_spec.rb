# encoding: UTF-8
require 'spec_helper'
require 'fakeweb'

require 'agcaldav'

describe AgCalDAV::Client do

  before(:each) do
    @c = AgCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar", :user => "user" , :password => "")
  end

  it "check Class of new calendar" do
    @c.class.to_s.should == "AgCalDAV::Client"
  end

  it "find one event" do
    FakeWeb.register_uri(:any, "http://localhost:5232/user/calendar/3bb14b40-3654-0130-7d41-109add70606c.ics", :body => "BEGIN:VCALENDAR\nPRODID:-//Radicale//NONSGML Radicale Server//EN\nVERSION:2.0\nBEGIN:VEVENT\nDESCRIPTION:12345 12ss345\nDTEND:20130101T110000\nDTSTAMP:20130101T161708\nDTSTART:20130101T100000\nSEQUENCE:0\nSUMMARY:123ss45\nUID:3bb14b40-3654-0130-7d41-109add70606c\nX-RADICALE-NAME:3bb14b40-3654-0130-7d41-109add70606c.ics\nEND:VEVENT\nEND:VCALENDAR")
  #  r = @c.find_event("85fcbaa0-364f-0130-7d3e-109add70606c")
  #  r.should_not be_nil
  #  r.length.should == 1
  end
end
