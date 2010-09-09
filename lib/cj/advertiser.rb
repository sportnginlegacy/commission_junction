module CommissionJunction
  class Advertiser < Base
    class << self
      def service_url
        base_url + "v3/advertiser-lookup"
      end
      
      def pages?
        true
      end
      
      def find(params)
        validate_params!(params, %w"advertiser-ids advertiser-name keywords page-number records-per-page")
        get_service(service_url, params)
      end # find
    end # << self
  end # Advertiser
end # CommissionJunction