require 'optparse'

# caldav --user USER --password PASSWORD --uri URI --command COMMAND
# caldav --user martin@solnet.cz --password test --uri https://mail.solnet.cz/caldav.php/martin.povolny@solnet.cz/test --command create_event 


module CalDAV

class CalDAVer
    def run_args( args )
        options = {}
        OptionParser.new do |o|
          o.on('-p', '--password', String, 'Password')      { |p| options[:password] = p }
          o.on('-u', '--user',     String, 'User (login)')  { |l| options[:login]    = l }
          o.on('--uri [STRING]',   String, 'Calendar URI')  { |uri| options[:uri]    = uri }
          o.on('-h') { puts o; exit }
        end.parse( args )
    end
end

end
