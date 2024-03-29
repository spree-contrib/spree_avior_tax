module SpreeAviorTax
  class AviorTax
    attr_reader :order, :line_item, :shipment, :client

    def initialize(order = nil, line_item = nil, shipment = nil)
      @order = order
      @line_item = line_item
      @shipment = shipment
      @client = SpreeAviorTax::Client.new client_params
    end

    delegate :login, to: :client

    def calculate_for_order(order, line_item)
      @order = order
      @line_item = line_item
      client.calculate_tax [line_item_params]
    end

    def calculate_for_shipment(order, shipment)
      @order = order
      @shipment = shipment
      client.calculate_tax [shipment_params]
    end

    private

    def client_params
      {
        service_url: SpreeAviorTax::Config[:service_url],
        token: SpreeAviorTax::Config[:token]
      }
    end

    def record_number(order)
      order.number.gsub(/^R/, '')
    end

    def line_item_params
      SpreeAviorTax::API::Input::Product.new(
        date: order.updated_at.strftime('%Y%m%d'),
        record_number: record_number(order),
        seller_id: SpreeAviorTax::Config[:seller_id],
        seller_location_id: SpreeAviorTax::Config[:seller_location_id],
        seller_state: SpreeAviorTax::Config[:seller_state],
        customer_entity_code: SpreeAviorTax::Config[:customer_entity_code],
        delivery_method: 'N',
        ship_to_address: order.tax_address.address1,
        ship_to_suite: order.tax_address.address2,
        ship_to_city: order.tax_address.city,
        ship_to_county: order.tax_address.county,
        ship_to_state: order.tax_address.state.abbr,
        ship_to_zip_code: order.tax_address.zipcode,
        ship_to_zip_plus: '',
        sku: line_item.variant.sku,
        amount_of_sale: line_item.discounted_amount
      )
    end

    def shipment_params
      SpreeAviorTax::API::Input::Product.new(
        date: order.updated_at.strftime('%Y%m%d'),
        record_number: record_number(order),
        seller_id: SpreeAviorTax::Config[:seller_id],
        seller_location_id: SpreeAviorTax::Config[:seller_location_id],
        seller_state: SpreeAviorTax::Config[:seller_state],
        customer_entity_code: SpreeAviorTax::Config[:customer_entity_code],
        delivery_method: 'N',
        ship_to_address: order.tax_address.address1,
        ship_to_suite: order.tax_address.address2,
        ship_to_city: order.tax_address.city,
        ship_to_county: order.tax_address.county,
        ship_to_state: order.tax_address.state.abbr,
        ship_to_zip_code: order.tax_address.zipcode,
        ship_to_zip_plus: '',
        sku: '',
        amount_of_sale: shipment.discounted_cost
      )
    end
  end
end
