module Kpcc
  class Client

    def get(path, params={})
      connection.get do |request|
        request.url path
        request.params = params
      end
    end


    private

    def connection
      @connection ||= begin
        Faraday.new(url: api_root) do |conn|
          conn.response :json
          conn.adapter Faraday.default_adapter
        end
      end
    end

    def api_root
      @api_root ||= "http://www.scpr.org/api/v2"
    end
  end
end
