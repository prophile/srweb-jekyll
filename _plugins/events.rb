require 'geocoder'
require 'facets/string/titlecase'


# A thin layer on top of Jekyll collections to represent an events subsystem.
module EventsSubsystem

    # A Liquid tag which gets the type of the event.
    #
    # Accepts two arguments separated by a space:
    # * The name of the variable holding the event.
    # * The format of the result. One of 'human' or 'raw'.
    class GetEventType < Liquid::Tag
        def initialize(tag_name, text, options)
            super

            tokens = text.split(' ')

            @event_name = tokens[0].strip
            @format = tokens[1].strip
        end

        def render(context)
            event = context[@event_name]
            type = event['relative_path'].split('/')[-2]

            case @format
            when 'raw'
                type
            when 'human'
                type.gsub(/-/, ' ').titlecase
            end
        end
    end

    # Format the dates in an event with 'human' output.
    def self.format_human_date(days)
        if days.size == 2
            day1 = Date.parse(days[0][0])
            day2 = Date.parse(days[1][0])

            a = day1.strftime('%e')
            b = day2.strftime('%e')
            c = day1.strftime('%B %Y')

            return "#{a}-#{b} #{c}"
        elsif days.size == 1
            date = Date.parse(days[0][0])
            date.strftime('%e %B %Y')
        else
            raise "Unsupported date format."
        end
    end

    # Format the dates in an event with 'human' output, and include the times.
    def self.format_human_datetime(days)
        content = []

        for day in days
            date = Date.parse(day[0])
            start_time = Time.parse(day[1])
            end_time = Time.parse(day[2])

            if start_time == end_time
                content << date.strftime('%e %B %Y')
            else
                a = start_time.strftime('%l:%M%P')
                b = end_time.strftime('%l:%M%P').strip  # preceeding space
                c = date.strftime('%e %B %Y')

                content << "#{a}-#{b}, #{c}"
            end
        end

        return content.join '<br />'
    end

    # Format the dates in an event with 'ics' output.
    def self.format_date_ics(year, month, day)
        "#{year}#{month}#{day}"
    end

    # Format the dates in an event with 'ISO' output.
    def self.format_date_iso(year, month, day)
        '%02i-%02i-%02i' % [year, month, day]
    end

    # A Liquid tag which gets the date of the event.
    #
    # Accepts two arguments separated by a space:
    # * The name of the variable holding the event.
    # * The format of the result. One of 'human', 'ics' or 'iso'.
    class GetDate < Liquid::Tag
        MATCHER = /^.*\/(.*)\..*$/

        def initialize(tag_name, text, options)
            super

            tokens = text.split(' ')

            @event_name = tokens[0].strip
            @format = tokens[1].strip
        end

        def render(context)
            event = context[@event_name]
            m, slug = *event['relative_path'].match(MATCHER)

            date = Date.parse(event['dates'][0][0])

            year = date.year
            month = date.month
            day = date.day

            case @format
            when "ics"
              EventsSubsystem::format_date_ics(year, month, day)
            when "iso"
              EventsSubsystem::format_date_iso(year, month, day)
            when "human"
              EventsSubsystem::format_human_datetime(event['dates'])
            end
        end
    end

    # A Liquid tag which outputs a list of events.
    #
    # Accepts four arguments separated by a space:
    # * The type of the events.
    # * The branch to show events for.
    # * The string to display when there are no events.
    # * Whether or not to include the locations.
    class HomeEvents < Liquid::Tag
        MATCHER = /^(\/.+)*\/(.*)$/
        SYNTAX = /(.*)[[:blank:]]*,[[:blank:]]*(.*)[[:blank:]]*,[[:blank:]]*(.*)[[:blank:]]*,[[:blank:]]*(.*)/

        def initialize(tag_name, markup, options)
            super
            m, @type, @branch, @default, @incl_locations = *markup.match(SYNTAX)
        end

        def render(context)
            sr_year = context['site.sr.year']

            branches = context['site.sr.branches']
            content = []

            branch = if @branch == 'all' then 'all' else context[@branch] end

            content << '<ul>'
            matched_any = false
            context['site.events'].each do |event|
                m, cats, slug = *event.cleaned_relative_path.match(MATCHER)

                cats = cats.split('/').drop(1)
                # filter by year
                next unless cats.include? "#{sr_year}"
                # filter by branch
                next unless event.data['branch'] == branch || branch == 'all'
                # filter by type
                next unless cats.include? @type
                pretty_date = EventsSubsystem::format_human_date(event.data['dates'])
                if @incl_locations.rstrip == "true" then
                    loc = event.data['location']
                    search_data = GeoLookup::lookup(loc)
                    name = nil
                    search_data['address_components'].each do |component|
                        name = component['short_name'] if component['types'].include?('establishment')
                    end
                    name = search_data['formatted_address'] if name.nil?
                    extra_goo = ", #{name}"
                end
                formatted_event = "<li><a href=\"#{event.url}\">#{pretty_date}</a>#{extra_goo}</li>"
                content << formatted_event
                matched_any = true
            end

            content << "<li>#{@default}</li>" unless matched_any
            content << "</ul>"

            content.join "\n"
        end

        private
        def make_list(elems)
            return "TBA" if elems.empty?
            "<ul>" + (elems.map {|x| "<li>#{x}</li>"}).join + "</ul>"
        end
    end
end

Liquid::Template.register_tag('events_list',
                              EventsSubsystem::HomeEvents)
Liquid::Template.register_tag('event_date',
                              EventsSubsystem::GetDate)
Liquid::Template.register_tag('event_type',
                              EventsSubsystem::GetEventType)
