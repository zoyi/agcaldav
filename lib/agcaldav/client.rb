module AgCalDAV
  class Client
    include Icalendar
    attr_accessor :host, :port, :url, :user, :password, :ssl

    def format=( fmt )
      @format = fmt
    end

    def format
      @format ||= Format::Debug.new
    end

    def initialize( data )
      unless data[:proxy_uri].nil?
        proxy_uri   = URI(data[:proxy_uri])
        @proxy_host = proxy_uri.host
        @proxy_port = proxy_uri.port.to_i
      end
      uri = URI(data[:uri])
      @host     = uri.host
      @port     = uri.port.to_i
      @url      = uri.path
      @user     = data[:user]
      @password = data[:password]
      @ssl      = uri.scheme == 'https'
    end

    def __create_http
      if @proxy_uri.nil?
        http = Net::HTTP.new(@host, @port)
      else
        http = Net::HTTP.new(@host, @port, @proxy_host, @proxy_port)
      end
      if @ssl
        http.use_ssl = @ssl
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http
    end

    def find_events data
      result = ""
      res = nil
      __create_http.start {|http|
        req = Net::HTTP::Report.new(@url, initheader = {'Content-Type'=>'application/xml'} )
        req.basic_auth @user, @password
        req.body = AgCalDAV::Request::ReportVEVENT.new(DateTime.parse(data[:start]).strftime("%Y%m%dT%H%M"),
                                                       DateTime.parse(data[:end]).strftime("%Y%m%dT%H%M") ).to_xml
        res = http.request(req)
        s = res.body
        result = ""
        xml = REXML::Document.new(s)
        REXML::XPath.each( xml, '//c:calendar-data/', {"c"=>"urn:ietf:params:xml:ns:caldav"} ){|c| result << c.text}
        r = Icalendar.parse(result)
        r.first

      }

     
    end

    def find_event uuid
      res = nil
      __create_http.start {|http|
        req = Net::HTTP::Get.new("#{@url}/#{uuid}.ics")
        req.basic_auth @user, @password
        res = http.request( req )
      }
      raise AuthenticationError if res.code.to_i == 401
      raise APIError if res.code.to_i >= 500
      r = Icalendar.parse(res.body)      
      r.first
    end

    def delete_event uuid
      __create_http.start {|http|
        req = Net::HTTP::Delete.new("#{@url}/#{uuid}.ics")
        req.basic_auth @user, @password
        res = http.request( req )
      }
    end

    def create_event event
      c = Calendar.new
      uuid = UUID.new.generate
      c.event do
        uid           uuid  # still a BUG
        dtstart       DateTime.parse(event[:start])
        dtend         DateTime.parse(event[:end])
        duration      event[:duration]
        summary       event[:title]
        description   event[:description]
        klass         event[:accessibility] #PUBLIC, PRIVATE, CONFIDENTIAL
        location      event[:location]
        geo_location  event[:geo_location]
        status        event[:status]
      end
      c.publish
      c.event.uid = uuid
      cstring = c.to_ical
      res = nil
      http = Net::HTTP.new(@host, @port)
      __create_http.start { |http|
        req = Net::HTTP::Put.new("#{@url}/#{uuid}.ics")
        req['Content-Type'] = 'text/calendar'
        req.basic_auth @user, @password
        req.body = cstring
        res = http.request( req )
      }
      raise AuthenticationError if res.code.to_i == 401
      raise APIError if res.code.to_i >= 500
      find_event uuid
      #{:uid => uuid, :cal => c, :cal_string => cstring, :response_code => res.code} #TODO
    end

    def add_alarm tevent, altCal="Calendar"
      # FIXME create icalendar event -> cal.event.new (tevent)

      # TODO




    end

    def update event
      # FIXME old one not neat

      # TODO
    end

    def todo
      res = nil
      __create_http.start {|http|
        req = Net::HTTP::Report.new(@url, initheader = {'Content-Type'=>'application/xml'} )
        req.basic_auth @user, @password
        req.body = AgCalDAV::Request::ReportVTODO.new.to_xml
        res = http.request( req )
      }
      # FIXME: process HTTP code
      format.parse_todo( res.body )
    end

    def filterTimezone( vcal )
      data = ""
      inTZ = false
      vcal.split("\n").each{ |l|
        inTZ = true if l.index("BEGIN:VTIMEZONE")
        data << l+"\n" unless inTZ
        inTZ = false if l.index("END:VTIMEZONE")
      }
      return data
    end
  end

  class AgCalDAVError < StandardError
  end
  class AuthenticationError < AgCalDAVError; end
  class APIError            < AgCalDAVError; end
end
