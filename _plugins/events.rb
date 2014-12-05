module EventsSubsystem
    class GetDate < Liquid::Tag
        MATCHER = /^.*\/(\d+)-(\d+)-(\d+)-(.*)\..*$/

        def initialize(tag_name, markup, options)
            super
        end

        def render(context)
            m, year, month, day, slug = *context['page']['relative_path'].match(MATCHER)
            months = %w[?? January February March
                        April May June
                        July August September
                        October November December]
            suffix = %w[th st nd rd th th th th th th
                        th th th th th th th th th th
                        th st nd rd th th th th th th
                        th st]
            "#{day}<sup>#{suffix[day.to_i]}</sup> #{months[month.to_i]}, #{year}"
        end
    end

    class HomeEvents < Liquid::Tag
        MATCHER = /^(\/.+)*\/(\d+-\d+-\d+)-(.*)$/
        def initialize(tag_name, markup, options)
            super
        end

        def render(context)
            sr_year = context['site']['sr']['year']

            kickstarts = []
            tech_days = []
            competitions = []

            context['site']['events'].each do |event|
                m, cats, date, slug = *event.cleaned_relative_path.match(MATCHER)
                cats = cats.split('/').drop(1)
                # filter by year
                next unless cats.include? "sr#{sr_year}"
                formatted_event = "<a href=\"#{event.url}\">#{date}</a><br>"
                kickstarts   << formatted_event if cats.include? "kickstart"
                tech_days    << formatted_event if cats.include? "tech_day"
                competitions << formatted_event if cats.include? "competition"
            end
            ("<h4>Kickstart</h4>" + make_list(kickstarts) +
             "<h4>Tech Days</h4>" + make_list(tech_days) +
             "<h4>Competition</h4>" + make_list(competitions))
        end

        private
        def make_list(elems)
            return "TBA" if elems.empty?
            "<ul>" + (elems.map {|x| "<li>#{x}</li>"}).join + "</ul>"
        end
    end
end

Liquid::Template.register_tag('home_events',
                              EventsSubsystem::HomeEvents)
Liquid::Template.register_tag('event_date',
                              EventsSubsystem::GetDate)

