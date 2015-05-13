require 'nokogiri'

# A subsystem to generate HTAccess files.
module HTAccessRedirects

    # A tag which generates a .htaccess file based on redirects.
    #
    # Accepts no arguments.
    class GenerateHTAccess < Liquid::Tag
        REDIRECT_BASE = "https://www.studentrobotics.org"

        def redirect_target(html)
            parse_tree = Nokogiri::HTML(html)
            canonical = parse_tree.at_css('link[rel="canonical"]')
            canonical['href']
        end

        def render(context)
            site = context['site']
            entries = []
            site['pages'].each do |page|
                if page.respond_to?(:generate_redirect_content)
                    target = redirect_target(page.output)
                    entries << "Redirect 302 #{page.url} #{REDIRECT_BASE}#{target}"
                end
            end
            entries.join("\n")
        end
    end
end

Liquid::Template.register_tag('htaccess_redirects', HTAccessRedirects::GenerateHTAccess)
