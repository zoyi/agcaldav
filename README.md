#Ruby CalDAV library named "agcaldav"
**agcaldav is a CalDAV library based on martinpovolny/ruby-caldav and 4fthawaiian/ruby-caldav and collectiveidea/caldav**

##Usage

First, you've to install the gem

    gem install agcaldav

and require it

    require "agcaldav"

Next you have to obtain the URI, username and password to a CalDAV-Server. If you don't have one try RADICALE (https://github.com/agilastic/Radicale). It's small, simple and written in python. In the following steps I'm using the default params of Radical.


Now you can e.g. create a new AgCalDAV-Client:
    	
	cal = AgCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar", :user => "user" , :password => "")

Alternatively, the proxy parameters can be specified:

	cal = AgCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar",:user => "user" , :password => "password, :proxy_uri => "http://my-proxy.com:8080")


####Create an Event and save it

    result = cal.create_event(:start => "2012-12-29 10:00", :end => "2012-12-30 12:00", :title => "12345", :description => "sdkvjsdf sdkf sdkfj sdkf dsfj")

Determine Event UID:

    result[:uid]


Find Event:
    
    r = cal.find_event(result[:uid])


Find Events within time interval:

    result = cal.find_events(:start => "2012-10-01 08:00", :end => "2013-01-01")
    #TODO.... (no XML -> Icalendar with multiple events....)



... next tomorrow ...


