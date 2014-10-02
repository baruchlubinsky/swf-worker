# This module defines functions for each of the HTTP verbs.
# All of the requests have infinite timeouts due to the potential for long
# running requests in the application.
# The underlying HHTP library may be replaced provided that the interface
# of the module is unchanged.

require 'rest-client'

module RestWrapper
  def self.set_error_method(func)
    @error = func
  end
  def self.get(url, error = 'An error occured in the request')
    RestClient.get(url) do |response, request, result|
      if result.code == "200"
        return response.body
      else
        @error.call error + "\r\n" + response.body
      end
    end
  end
  def self.post(url, data, error = 'An error occured in the request')
    RestClient::Request.execute(method: :post, url: url, payload: data, timeout: -1, open_timeout: -1, headers: {content_type: 'application/json'}) do |response, request, result|
      if result.code == "200"
        return response.body
      else
        @error.call error + "\r\n" + response.body
      end
    end
  end
  def self.put(url, data, error = 'An error occured in the request')
    RestClient::Request.execute(method: :put, url: url, payload: data, timeout: -1, open_timeout: -1, headers: {content_type: 'application/json'}) do |response, request, result|
      if result.code == "200"
        return response.body
      else
        @error.call error + "\r\n" + response.body
      end
    end
  end
	def self.unsafe_put(url, data, error = 'An error occured in the request')
		RestClient::Request.execute(method: :put, url: url, payload: data, timeout: -1, open_timeout: -1, headers: {content_type: 'application/json'})
	end
  def self.delete(url)
    raise 'Unimplemented method RestWrapper.delete'
  end
end
