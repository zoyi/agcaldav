require './lib/caldav.rb'

class CaldavTester

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
        
        @cal = Caldav.new $caldav[:host], $caldav[:port], $caldav[:url], $caldav[:user], $caldav[:password]
    end

    attr :cal

    def test_create_event
        myevent = Event.new
        myevent.dtstart = DateTime.parse( '2012/08/08 09:45')
        myevent.dtend = DateTime.parse( '2012/08/08 10:45')
        myevent.summary = "Yo Yo YO"
        
        
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
        res = cal.todo
        
        res.each{ |todo| 
            p todo
        }
    end
    
    def test_report
        p cal.report "20111201T000000", "20131231T000000"
    end
end

#r = CalDAV::Request::Report.new( "20111201T000000", "20131231T000000" )
#puts r.to_xml
#exit

t = CaldavTester.new

uuid = t.test_create_event
t.test_get_event( uuid )
t.test_delete_event( uuid )

t.test_report

t.test_read_todo


