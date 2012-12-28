#Ruby CalDAV library named "agcaldav"
**agcaldav is a CalDAV library based on martinpovolny/ruby-caldav and 4fthawaiian/ruby-caldav and collectiveidea/caldav**

##Usage

First, you've to install the gem

    gem install agcaldav

and require it

    require "agcaldav"

Next you have to obtain the URI, username and password to a CalDAV-Server. If you don't have one try RADICALE (https://github.com/agilastic/Radicale). It's small, simple and written in python. In the following steps I'm using the default params of Radical.


Now you can e.g. create a new AGCalDAV-Client:
		
	cal = AGCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar", :user => "user" , :password => "password")

Alternatively, the proxy parameters can be specified:

	cal = AGCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar",:user => "user" , :password => "password, :proxy_uri => "http://my-proxy.com:8080")

