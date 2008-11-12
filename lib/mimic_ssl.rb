module MimicSsl
  module ActionController
    
    module UrlRewriter
      def self.included(base)
        base.alias_method_chain :rewrite_url, :mimic_ssl
      end

      private
      def rewrite_url_with_mimic_ssl(options)
        protocol = options[:protocol]
        options[:protocol] = "http" if protocol == "https"
        url = rewrite_url_without_mimic_ssl(options)
        uri = URI.parse(url)
        if protocol == "https" or (protocol.nil? and @request.ssl?)
          url = uri.query.nil? ? url + "?" : url + "&"
          url + "ssl=1"
        else
          url
        end
      end
    end
    ::ActionController::UrlRewriter.send :include, UrlRewriter
    
    module AbstractRequest
      def self.included(base)
        base.class_eval do
          def protocol
            'http://'
          end
          
          def ssl_with_mimicking?
            query_parameters.stringify_keys['ssl'] == '1' || ssl_without_mimicking?
          end
          alias_method_chain :ssl?, :mimicking
        end
      end
    end
    ::ActionController::AbstractRequest.send :include, AbstractRequest
    
  end

  module SslRequirement
    def self.included(base)
      base.class_eval do
        def construct_uri_from_request(with_ssl)
          url = "http://#{request.host_with_port + request.request_uri}"
          uri = URI.parse(url)
          if with_ssl
            url = uri.query.nil? ? url + "?" : url + "&"
            url + "ssl=1"
          else
            url.gsub(/(?:\?|&)ssl=1/, '')
          end
        end

        def ensure_proper_protocol
          return true if ssl_allowed?

          if ssl_required? && !request.ssl?
            redirect_to construct_uri_from_request(with_ssl = true)
            flash.keep
            return false
          elsif request.ssl? && !ssl_required?
            redirect_to construct_uri_from_request(with_ssl = false)
            flash.keep
            return false
          end
        end          
      end
    end
  end
  ::SslRequirement.send :include, SslRequirement
  
end