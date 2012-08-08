require './lib/caldav.rb'

class CalDAVTester

    def initialize
        $caldav = {
            :host     => 'mail.server.com',
            :port     => 443,
            :url      => '/caldav.php/martin.povolny@solnet.cz/test',
            :user     => 'user@test.com',
            :password => 'yourpassword'
        }
        begin
            require '~/.caldav_cred.rb'
        rescue LoadError
        end
        
        @cal = CalDAV::Client.new $caldav[:host], $caldav[:port], $caldav[:url], $caldav[:user], $caldav[:password]
    end

    attr :cal

    def test_create_event
        myevent = Event.new
        myevent.dtstart = DateTime.parse( '2012/08/11 09:45')
        myevent.dtend = DateTime.parse( '2012/08/11 10:45')
        myevent.summary = "Jo?"
        
        uuid, response = cal.create myevent
        
        puts "CREATE Response #{response.code} #{response.message}: #{response.body}"
        puts "UUID: #{uuid}"

        return uuid
    end

    def test_delete_event( uuid )
        response = cal.delete uuid
        puts "DETELE Response #{response.code} #{response.message}: #{response.body}"
    end

    def test_get_event( uuid )
        ev, response = cal.get uuid
        puts "GET Response #{response.code} #{response.message}: #{response.body}"
        puts ev
    end

    def test_read_todo
        puts '*' * 20 + ' TODO ' + '*' * 20
        res = cal.todo
        
        res.each{ |todo| 
            p todo
        }
    end
    
    def test_report
        puts '*' * 20 + ' EVENTS ' + '*' * 20
        p cal.report "20111201T000000", "20131231T000000"
    end

    def test_query0
        puts CalDAV::Query.event.to_xml

        time1 = DateTime.parse('2011/08/08 09:45')
        time2 = DateTime.parse('2012/08/08 10:45')
        puts CalDAV::Query.event(time1..time2).to_xml
        puts CalDAV::Query.event.uid( UUID.generate ).to_xml
        #puts CalDAV::Query.todo.alarm(time1..time2).to_xml
        #puts CalDAV::Query.event.attendee(email).partstat('NEEDS-ACTION').to_xml
        #puts CalDAV::Query.todo.completed(false).status(:cancelled => false).to_xml
    end

    def test_query
        p cal.query( CalDAV::Query.event ) #=> All events
        p cal.query( CalDAV::Query.event(time1..time2) )
        p cal.query( CalDAV::Query.event.uid("UID") )
        p cal.query( CalDAV::Query.todo.alarm(time1..time2) )
        p cal.query( CalDAV::Query.event.attendee(email).partstat('NEEDS-ACTION') )
        p cal.query( CalDAV::Query.todo.completed(false).status(:cancelled => false) )
    end
end

#r = CalDAV::Request::Report.new( "20111201T000000", "20131231T000000" )
#puts r.to_xml
#exit

t = CalDAVTester.new

t.test_query0

uuid = t.test_create_event
t.test_get_event( uuid )
t.test_delete_event( uuid )

t.test_report
t.test_read_todo
#t.test_query

