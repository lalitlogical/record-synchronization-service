class SynchronizationService
  def initialize(order_id, action)
    @order_id = order_id
    @order = Order.find(order_id) unless action == "destroy"
    @action = action
  end

  def synchronize
    client = HttpClient.new(host: EXTERNAL_HOST)
    client.send(http_method, order_routes, params, token: SecureRandom.hex(16))
  end

  def tranform
    @tranform ||= Transform.external_payload(@order)
  end

  private

  def order_routes
    case @action
    when "update", "destroy"
      "/v1/orders/#{@order_id}"
    when "create", "list", "get"
      "/v1/orders"
    end
  end

  def params
    case @action
    when "update", "create"
      tranform
    else
      nil
    end
  end

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
