module CommissionJunction
  class Base
    include HTTParty
    format :xml 
    
    @@credentials = {}
    @@default_params = {}
    
    def initialize(params)
      raise ArgumentError, "Init with a Hash; got #{params.class} instead" unless params.is_a?(Hash)

      params.each do |key, val|
        instance_variable_set("@#{key}".intern, val)
        instance_eval " class << self ; attr_reader #{key.intern.inspect} ; end "
      end
    end
    
    def developer_key=(key)
      @@credentials['developer_key'] = key.to_s
    end
    
    def website_id=(id)
      @@credentials['website_id'] = id.to_s
    end
    
    
    class << self
      def base_url
        "https://api.cj.com/"
      end
      
      def validate_params!(provided_params, available_params, default_params = {})
        params = default_params.merge(provided_params)
        invalid_params = params.select{|k,v| !available_params.include?(k.to_s)}.map{|k,v| k}
        raise ArgumentError.new("Invalid parameters: #{invalid_params.join(', ')}") if invalid_params.length > 0
      end
      
      def get_service(path, query)
        # set the developer key header as default in HTTParty
        self.headers('authorization' => credentials['developer_key'])
        query.keys.each{|k| query[k.to_s] = query.delete(k)}
        query.merge!({'page-number' => 1, 'records-per-page' => 100}) if pages?

        results = []
        total = 0

        begin
          begin
            response = get(path, :query => query, :timeout => 30)
          rescue Timeout::Error
            nil
          end

          cj_api = response['cj_api']
          validate_response(cj_api)

          #little bit of navigation here
          total = cj_api.values.first.delete('total_matched').to_i
          
          # cj_api is a hash containing a hash or return data, one element being the actual records we have
          data = cj_api.values.first.reject{|k,v| %w{records_returned page_number}.include?(k)}.values.first
          data = [data] unless data.is_a?(Array)
          results = results.concat(data || [])

          query['page-number'] += 1 if query['page-number']
        end while total > results.length

        results.map{|r| self.new(r)}
      end # get
      
      def credentials
        unless @@credentials && @@credentials.length > 0
          # there is no offline or test mode for CJ - so I won't include any credentials in this gem
          config_file = "config/commision_junction.yml"
          config_file = File.join(ENV['HOME'], '.commission_junction.yaml') unless File.exist?(config_file)

          unless File.exist?(config_file)
            warn "Warning: #{key_file} does not exist. Put your CJ developer key and website ID in ~/.commision_junction.yml to enable live testing."
          else
            @@credentials = YAML.load(File.read(config_file))
          end
        end
        @@credentials
      end # credentails
      
      def validate_response(response)
        error_message = response['error_message']
        raise ArgumentError, error_message if error_message
      end
      
      def first(params)
        find(params).first
      end
    
    end # self
  end # Base
end # CommisionJunction