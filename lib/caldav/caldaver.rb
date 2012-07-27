require 'optparse'

# caldav --user USER --password PASSWORD --uri URI --command COMMAND
# caldav --user martin@solnet.cz --password test --uri https://mail.solnet.cz/caldav.php/martin.povolny@solnet.cz/test --command create_event 

module CalDAV

class CalDAVer
    def run_args( args )
        o = nil

        help = Proc.new do
            puts o.help
            exit 1
        end

        options = {}
        o = OptionParser.new do |o|
            o.on('-p', '--password',      String, 'Password')     { |p|   options[:password] = p }
            o.on('-u', '--user',          String, 'User (login)') { |l|   options[:login]    = l }
            o.on('--uri [STRING]',        String, 'Calendar URI') { |uri| options[:uri]      = uri }
            o.on('--command [STRING]',    String, 'Command')      { |c|   options[:command]  = command }
            o.on('--begin [DATETIME]',    DateTime, 'Start time') { |dt|  options[:begin]    = dt }
            o.on('--end [DATETIME]',      DateTime, 'End time')   { |dt|  options[:end]      = dt }
            o.on('-h') { help.call }
        end

        o.parse( args )

        help.call if options[:command].to_s.empty? or options[:uri].to_s.empty?

        cal = cal.new( options[:uri], options[:login], options[:password] )

        case options[:command].to_s
        when 'create'
        when 'delete'
        #when 'modify'
        when 'get'
        when 'report'
            cal.report( options[:begin], options[:end] )
        else
            help.call
        end
    end
end

end
