require "active_merchant_pay2go_cvs/version"
require "active_merchant"

module ActiveMerchant
  module Billing
    module Integrations
      autoload :Pay2goCvs, 'active_merchant/billing/integrations/pay2go_cvs'
    end
  end
end
