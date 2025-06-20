class InboundController < ApplicationController
  before_action :set_order

  def update
    if @order.update(Transform.internal_payload(order_params))
      render json: { message: "Order record updated successfully." }
    else
      render json: { message: "Order record does not updated successfully." }
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
    @order.skip_syncing = true
  end

  def order_params
    params[:order].permit(:status, :delivered_on)
  end
end
