module Filters
	def expand_urls(input, url='')
		url ||= '/'
		input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
			$1+url+$3
		end
	end

	def asset_url(input)
		if input[0] == '/'
			raise 'input can not start with slash!'
		end

		base = @context.registers[:site].config['content_assets_base']
		return base + input
	end
end

Liquid::Template.register_filter Filters
