require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.request_headers_to_include = ['Content-Type']
  config.docs_dir = Rails.root.join('doc/api')
  config.request_body_formatter = proc do |body|
    JSON.pretty_generate(body) if body.present?
  end
  config.api_name = 'API Documentation'
end
