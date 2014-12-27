module DocsSubsystem
  class HierarchicalIndexTag < Liquid::Tag
    def initialize(tag_name, leader, tokens)
      super
      @leader = leader.strip
    end

    def common_prefix(a, b)
      prefixed_pairs = a.zip(b).take_while { |pair| pair[0] == pair[1] }
      prefixed_pairs.map { |a, b| a }
    end

    def real_url(page_url)
      return nil unless page_url.start_with?(@leader)
      page_url[@leader.length..-1]
    end

    def render(context)
      pages = context['site.pages'].sort_by { |page|
        page.url
      }
      result = ""
      previous_section = []
      all_urls = pages.map { |page| real_url(page.url) }
      all_urls.compact!
      pages.each do |page|
        url = real_url(page.url)
        next if url.nil?
        url_elements = url.split('/').select { |x| x.length > 0 }
        if url_elements.empty?
          title = "docs" # TODO: don't hard-code this
        else
          title = url_elements[-1].gsub('_', ' ')
        end
        # Calculate opening and closing of lists by length of common prefix
        section = url_elements[0...-1]
        common = common_prefix(section, previous_section)
        # Close previous sections
        result += "</ul>"*(previous_section.length - common.length)
        # Open new sections
        result += "<ul>"*(section.length - common.length)
        is_opener = all_urls.any? { |page_url|
          page_url != url and page_url.start_with?(url)
        }
        result += "<li>"
        if is_opener then
          result += "<strong>"
        end
        result += "<a href=\"#{@leader}#{url}\">#{title}</a>\n"
        if is_opener then
          result += "</strong>"
        end
        result += "</li>\n"
        previous_section = section
      end
      result += "</ul>"*previous_section.length
      result
    end
  end
end

Liquid::Template.register_tag('docs_hierarchical_index', DocsSubsystem::HierarchicalIndexTag)

