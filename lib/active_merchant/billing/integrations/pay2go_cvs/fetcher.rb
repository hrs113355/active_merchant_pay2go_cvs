require 'net/http'
require 'uri'
require 'openssl'
require 'json'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Pay2goCvs
        class Fetcher
          attr_accessor :params

          def initialize(params)
            raise 'parameter missmatch' if params['CheckValue'] != ActiveMerchant::Billing::Integrations::Pay2goCvs.fetch_url_encode_data(params)
            @params = pay2go_params(params)
          end

          def fetch
            result = RestClient.post ActiveMerchant::Billing::Integrations::Pay2goCvs.gateway_url, { 
              MerchantID_: ActiveMerchant::Billing::Integrations::Pay2goCvs.merchant_id,
              PostData_: encrypted_data(@params.to_query)
            }
            if @params['RespondType'] == 'JSON'
              JSON.parse(result)
            else
              result
            end
          end

          private

          def pay2go_params(params)
            params.permit(:RespondType, :TimeStamp, :Version, :MerchantOrderNo, :Amt, :ProdDesc, :AllowStore, :NotifyURL, :ExpireDate, :Email)
          end

          def padding(str, blocksize = 32)
            len = str.size
            pad = blocksize - (len % blocksize)
            str += pad.chr * pad
          end

          def encrypted_data(data)
            cipher = OpenSSL::Cipher::AES.new(256, :CBC)
            cipher.encrypt
            cipher.padding = 0
            cipher.key = ActiveMerchant::Billing::Integrations::Pay2goCvs.hash_key
            cipher.iv = ActiveMerchant::Billing::Integrations::Pay2goCvs.hash_iv
            data = padding(data)
            encrypted = cipher.update(data) + cipher.final
            encrypted.unpack('H*').first
          end
        end
      end
    end
  end
end
