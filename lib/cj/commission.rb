module CommissionJunction
  class Commission < Base
    class << self
      def service_url
        base_url + "v3/commissions"
      end
      
      def pages?
        false
      end
      
      def find(params = {})
        validate_params!(params, %w{date-type cids action-types aids action-status commission-id website-ids})
        # date-type is required
        params = {'date-type' => 'event'}.merge(params)
        get_service(service_url, params)
      end
      
    end # << self
  end # class
end # module