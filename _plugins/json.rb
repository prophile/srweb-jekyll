module BetterJsonFilter
    def to_json(input)
        JSON.generate(input)
    end
end

Liquid::Template.register_filter(BetterJsonFilter)
