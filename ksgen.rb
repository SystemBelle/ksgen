require 'sinatra'
require 'cgi'

# Ksgen - A Ruby/Sinatra program to generate Kickstart files or Arch Linux
# install scripts based on the given URL from ERB templates

set :environment, :development
set :views, [ 'snippets', 'templates' ]

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# "find_template" method is used by Sinatra if you define it
helpers do
	def find_template(views, name, engine, &block)
		Array(views).each { |v| super(v, name, engine, &block) }
	end
end

get '/:distro/:version/:disk_profile/?' do
	content_type 'text/plain'

	# parameters
	@distro = params['distro']
	@version = params['version']
	@disk_profile = params[:disk_profile]

	# get query params from url
	@query = CGI.parse(request.query_string)

	# optional query parameters
	@snippets = @query['snippet'] # return array, multiple snippet parameters allowed
	@arch_ = @query['arch'][0]
	@datacenter = @query['datacenter'][0]

	# defaults
	@arch ||= 'x86_64'
	@datacenter ||= "#{Default_datacenter}"

	# Render file
	@template = @distro + '-' + @version
	erb :"#{@template}"
end

