# ActiveMerchantPay2goCvs

智付寶超商代碼幕後取號的 ActiveMerchant plugin,，並不是透過 MPG (Multi Payment Gateway) 進行串接，而是專門為了在不離開網站的情況下幕後取得超商代碼，與 CVS API gateway 介接。

## Installation

Add this line to your application's Gemfile:

    gem 'active_merchant_pay2go_cvs', github:'hrs113355/active_merchant_pay2go_cvs'

## Usage


``` ruby

# config/environments/development.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :development
end

# config/environments/production.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :production
end

```

``` ruby

# initializers/pay2go_cvs.rb
ActiveMerchant::Billing::Integrations::Pay2goCvs.setup do |pay2go_cvs|
  pay2go_cvs.merchant_id = YOUR_MERCHANT_ID
  pay2go_cvs.hash_key    = YOUR_HASH_KEY
  pay2go_cvs.hash_iv     = YOUR_HASH_IV
end
```

## Example Usage

Once you’ve configured ActiveMerchantPay2goCvs, you need a checkout form; it looks like:

``` ruby
  <% payment_service_for  @order,
                          @order.user.email,
                          :service => :pay2go,
                          :credential3 => get_cvs_order_path, # 用來接收參數並幕後取得超商代碼的 controller/action URL
                          :html    => { :id => 'pay2go-checkout-form', :method => :post } do |service| %>
    <% service.merchant_order_no @order.payments.last.identifier %>
    <% service.respond_type "JSON" %>
    <% service.time_stamp @order.created_at.to_i %>
    <% service.version "1.0" %>
    <% service.product_desc @order.number %>
    <% service.amt @order.money %>
    <% service.email @order.buyer.email %>
    <% service.expire_date (@order.created_at + 7.days).strftime('%Y%m%d') %>
    <% service.notify_url pay2go_return_url %>
    <% service.encrypted_data %>
    <%= submit_tag 'Buy!' %>
  <% end %>
```

And add fetcher to the customized service url (the `credential3` field) to process CVS code fetching.

```ruby
  class OrdersController < ApplicationController
  
    def get_cvs
      fetch_result = ActiveMerchant::Billing::Integrations::Pay2goCvs::Fetcher.new(params).fetch
      cvs_code = fetch_result['Result']['CVSCode']
    end
```

Also need a notification action when Pay2goCvs service notifies your server; it looks like:

``` ruby
  def notify
    notification = ActiveMerchant::Billing::Integrations::Pay2goCvs::Notification.new(request.raw_post)

    order = Order.find_by_number(notification.merchant_order_no)

    if notification.status && notification.checksum_ok?
      # payment is compeleted
    else
      # payment is failed
    end

    render text: '1|OK', status: 200
  end
```

## Troublechooting
If you get a error "undefined method \`payment\_service\_for\`", you can add following configurations to initializers/pay2go_cvs.rb. 
```
require "active_merchant/billing/integrations/action_view_helper"
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
```


