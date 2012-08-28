require 'optparse'

# caldav --user USER --password PASSWORD --uri URI --command COMMAND
# caldav --user martin@solnet.cz --password test --uri https://mail.solnet.cz/caldav.php/martin.povolny@solnet.cz/test --command create_event 

module CalDAV

class CalDAVer

    def create_object( options )
        if options[:raw]
            # STDIN
            return STDIN.read(nil)
        else
            # options[:subject]
            # options[:login]
            # options[:summary]
            # options[:begin]
            # options[:end]
            # options[:due]
            case options[:what].intern
            when :task
                # FIXME
            when :event
                # FIXME
            when :contact
                # FIXME
            else
                print_help_and_exit if options[:command].to_s.empty? or options[:uri].to_s.empty?
            end
        end
    end

    def print_help_and_exit
        puts @o.help
        exit 1
    end

    def run_args( args )
        options = {}
        @o = OptionParser.new do |o|
            o.on('-p', '--password',      String, 'Password')     { |p|   options[:password] = p }
            o.on('-u', '--user',          String, 'User (login)') { |l|   options[:login]    = l }
            o.on('--uri [STRING]',        String, 'Calendar URI') { |uri| options[:uri]      = uri }
            o.on('--format [STRING]',     String, 'Format of output: raw,pretty,[debug]') { 
                                                                    |fmt| options[:fmt]  = fmt }
            o.on('--command [STRING]',    String, 'Command')      { |c|   options[:command]  = command }
            # what to create
            o.on('--what [STRING]',       String, 'Event/task/contact') { |c| options[:command]  = command }
            o.on('--raw',                         'Read raw data (event/task/contact) from STDIN') { |raw|   options[:raw] = true }
            # report and event options
            o.on('--begin [DATETIME]',    String, 'Start time')   { |dt|  options[:begin]    = dt }
            o.on('--end [DATETIME]',      String, 'End time')     { |dt|  options[:end]      = dt }
            o.on('--due [DATETIME]',      String, 'Due time')     { |dt|  options[:due]      = dt }
            #o.on('--begin [DATETIME]',    DateTime, 'Start time') { |dt|  options[:begin]    = dt }
            #o.on('--end [DATETIME]',      DateTime, 'End time')   { |dt|  options[:end]      = dt }
            # event options
            o.on('--summary  [string]',   String, 'summary of event/task')  { |s|  options[:summary]  = s }
            o.on('--location [string]',   String, 'location of event/task') { |s|  options[:location] = s }
            o.on('--subject  [string]',   String, 'subject of event/task')  { |s|  options[:subject]  = s }
            o.on('-h') { print_help_and_exit }
        end

        @o.parse( args )

        print_help_and_exit if options[:command].to_s.empty? or options[:uri].to_s.empty?

        cal = cal.new( options[:uri], options[:login], options[:password] )

        if options[:format]
            cal.format = case options[:format].intern
                when :raw
                    CalDAV::Format::Raw.new
                when :pretty
                    CalDAV::Format::Pretty.new
                when :debug
                    CalDAV::Format::Debug.new
                else
                    nil
            end
        end

        case options[:command].intern
        when :create
            obj = create_object( options )
        when :delete
        when :modify
            obj = create_object( options )
        when :get
        when :report
            cal.report( options[:begin], options[:end] )
        else
            print_help_and_exit
        end
    end
end

end
