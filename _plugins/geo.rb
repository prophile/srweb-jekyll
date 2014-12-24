module GeoSubsystem
    SYNTAX = /([[:graph:]]*)[[:blank:]]*,[[:blank:]]*([[:graph:]]*)/

    class ReverseGeocode < Liquid::Tag
        def initialize(tag_name, text, options)
            super
            m, @query, @component = *text.match(SYNTAX)
        end

        def render(context)
            raw_data = GeoLookup::lookup(context[@query])
            case @component
            when "address"
              raw_data['formatted_address']
            when "html_address"
              raw_data['formatted_address'].split(',').uniq.join('<br>')
            when "geo"
              coords = raw_data['geometry']['location']
              "#{coords['lat']},#{coords['lng']}"
            when "address_meta"
              address = raw_data['address_components']
              start_tag = '<span itemprop="address" itemscope itemtype="http://schema.org/Address">'
              end_tag = '</span>'
              items = address.map { |x| "<meta itemprop=\"#{x['types'][0]}\" content=\"#{x['long_name']}\">" }
              start_tag + items.join + end_tag
            when "geo_meta"
              coords = raw_data['geometry']['location']
              "#{coords['lat']},#{coords['lng']}"
              <<-eom
                <span itemprop="geo" itemscope itemtype="http://schema.org/Geo">
                  <meta itemprop="latitude" content="#{coords['lat']}">
                  <meta itemprop="longitude" content="#{coords['lng']}">
                </span>
              eom
            else
              "unknown location"
            end
        end
    end
end

Liquid::Template.register_tag('reverse_geocode',
                              GeoSubsystem::ReverseGeocode)
