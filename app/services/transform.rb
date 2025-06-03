class Transform
  # TODO: Write logic for Internal payload
  def self.internal_payload(changes)
  end

  def self.external_payload(order)
    {
      "status" => order.status,
      "purchased_date" => order.placed_at ? order.placed_at.strftime("%d/%m/%Y") : "",
      "delivery_date" => order.delivered_at ? order.delivered_at.strftime("%d/%m/%Y") : "",
      "cost" => order.amount + order.tax,
      "address" => order.full_address
    }
  end
end
