require 'sinatra'
require 'cgi'
require './conf.rb'

# Ksgen - A Ruby/Sinatra program to generate Kickstart files or Arch Linux
# install scripts based on the given URL from ERB templates
# can change disk profile and cpu arch via url, others need separate profiles

set :environment, :development
set :views, [ 'snippets', 'profiles' ]

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# "find_template" method is used by Sinatra if you define it
helpers do
	def find_template(views, name, engine, &block)
		Array(views).each { |v| super(v, name, engine, &block) }
	end
end

get '/:profile/:storage/?' do
	content_type 'text/plain'

	# Defaults
	@arch = settings.arch
	@filesystem = settings.filesystem

	# parameters
	@profile = params['profile']
	@storage = params['storage']

	# get query params from url
	@query = CGI.parse(request.query_string)

	# optional query parameters static?  can't we make this more flexible?
	@snippets = @query['snippet'] # return array, multiple snippet parameters allowed

	# Use defaults if value not given - needs to be DRY'd or put into subroutine
	@arch = @query['arch'][0]
	@arch.nil? && @arch = settings.arch
	@hostname = @query['hostname'][0]
	@hostname.nil? && @hostname = settings.hostname
	@filesystem = @query['filesystem'][0]
	@filesystem.nil? && @filesystem = settings.filesystem
	@version = @query['version'][0]
	@version.nil? && @version = '0'
	@location = @query['location'][0]
	@location.nil? && @location = 'unspecified'


	erb :"#{@profile}"
end

