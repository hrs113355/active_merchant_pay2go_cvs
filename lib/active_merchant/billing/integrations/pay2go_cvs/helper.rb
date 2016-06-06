#encoding: utf-8

require 'cgi'
require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Pay2goCvs
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          ### 常見介面
          # 廠商編號
          mapping :merchant_id, 'MerchantID'
          mapping :account, 'MerchantID' # AM common
          # 回傳格式
          mapping :respond_type, 'RespondType'
          # 時間戳記
          mapping :time_stamp, 'TimeStamp'
          # 串接程式版本
          mapping :version, 'Version'
          # 廠商交易編號
          mapping :merchant_order_no, 'MerchantOrderNo'
          mapping :order, 'MerchantOrderNo' # AM common
          # 交易金額（幣別：新台幣）
          mapping :amt, 'Amt'
          mapping :amount, 'Amt' # AM common
          # 商品資訊（限制長度50字）
          mapping :product_desc, 'ProdDesc'
          # 繳費超商 (not required)
          mapping :allow_store, 'AllowStore'
          # 支付通知網址
          mapping :notify_url, 'NotifyURL'
          # 繳費有限期限，格式範例：20140620
          mapping :expire_date, 'ExpireDate'
          # 付款人電子信箱
          mapping :email, 'Email'
          mapping :credential3, 'CustomizedUrl'

          def initialize(order, account, options = {})
            super
            add_field 'MerchantID', ActiveMerchant::Billing::Integrations::Pay2goCvs.merchant_id
          end

          def credential_based_url
            @fields['CustomizedUrl']
          end

        end
      end
    end
  end
end
