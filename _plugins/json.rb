# A Jekyll filter which converts the object to JSON and outputs it.
module BetterJsonFilter
    def to_json(input)
        JSON.generate(input)
    end
end

Liquid::Template.register_filter(BetterJsonFilter)
