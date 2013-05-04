module Filters
	def expand_urls(input, url='')
		url ||= '/'
		input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
			$1+url+$3
		end
	end

	def asset_url(input)
		base = @context.registers[:site].config['content_assets_base']
		URI.join(base, input)
	end
end

Liquid::Template.register_filter Filters
