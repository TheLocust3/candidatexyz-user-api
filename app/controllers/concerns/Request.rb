require 'httparty'

module Request
    extend ActiveSupport::Concern
  
    def post(url, data)
        response = HTTParty.post(url, {
            data: data,
            headers: {
                uid: request.headers['uid'],
                client: request.headers['client'],
                'access-token': request.headers['access-token']
            }
        })

        response.parsed_response
    end
end
