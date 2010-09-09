module CommissionJunction
  class Product < Base
    class << self
      def service_url
        base_url + "v2/product-search"
      end
      
      def pages?
        true
      end
      
      def find(params)
        validate_params!(params, %w{website-id advertiser-ids keywords serviceable-area
          isbn upc manufacturer-name manufacturer-sku advertiser-sku low-price high-price low-sale-price
          high-sale-price currency sort-by sort-order})
        params = {'website-id' => credentials['website_id']}.merge(params)
        get_service(service_url, params)
      end # find
    end # << self
  end # class
end # module