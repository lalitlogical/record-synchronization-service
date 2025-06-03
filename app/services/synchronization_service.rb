class SynchronizationService
  # Intialize synchronize service order_id and based on action
  def initialize(order_id, action)
    Rails.logger.info "Synchronization Service Initializing....."
    Rails.logger.info "-" * 75

    @order_id = order_id
    @order = Order.find(order_id) unless action == "destroy"
    @action = action

    Rails.logger.info "Order Id: #{order_id} | Action: #{action}"
    Rails.logger.info "-" * 75
  end

  # Synchronize order with external service
  def synchronize
    client = HttpClient.new(host: EXTERNAL_HOST)

    Rails.logger.info "Synchronizing the Order with parameters: #{params}"
    Rails.logger.info "-" * 75

    client.send(http_method, order_routes, params, token: SecureRandom.hex(16))
  end

  # Transform payload before sending to external service
  def transform
    @transform ||= Transform.external_payload(@order)
  end

  private

  # Prepare the routes based on action taken
  def order_routes
    case @action
    when "update", "destroy"
      "/v1/orders/#{@order_id}"
    when "create", "list", "get"
      "/v1/orders"
    end
  end

  # Prepare the parameters to sync with external service
  def params
    case @action
    when "update", "create"
      transform
    else
      nil
    end
  end

  # Prepare the mode of API calling to sync with external service
  def http_method
    (
      case @action
      when "update"
        "put"
      when "create"
        "post"
      when "destroy"
        "delete"
      when "list", "get"
        "get"
      end
    ).to_sym
  end
end
