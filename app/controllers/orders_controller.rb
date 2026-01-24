class OrdersController < ApplicationController
  def index
    @orders = Order.where(progress: %w[preparing ready]).order(:color, :number, :tyholt,:pina,:mojito)
  end

  def public_index
    @orders_in_preparation = Order.where(progress: :preparing).order(:color, :number)
    @orders_ready = Order.where(progress: :ready).order(:color, :number)
  end

  def new
    @order = Order.new(number: session[:number], color: session[:color], tyholt: session[:tyholt], pina: session[:pina], mojito: session[:mojito])
  end

  def create
    tweaker = order_params
    if tweaker["tyholt"] == "0"
      tweaker["tyholt"] = nil
    end
    if tweaker["pina"] == "0"
      tweaker["pina"] = nil
    end
    if tweaker["mojito"] == "0"
      tweaker["mojito"] = nil
    end
    
    @order = Order.new(tweaker.merge({ progress: :preparing }))
    if @order.save
      session[:number] = @order.number + 1
      session[:color] = @order.color

      @new_order = Order.new(number: @order.number + 1, color: @order.color)
    end
  end

  def destroy
    @order = Order.find(params[:id])

    if @order.delivered?
      CompletedOrder.create!(
        number:  @order.number,
        color:   @order.color,
        tyholt:  @order.tyholt,
        pina:    @order.pina,
        mojito:  @order.mojito
      )
      @order.delete
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def ready
    puts "READY"
    @order = Order.find(params[:id])

    @order.ready!
  end

  def deliver
    @order = Order.find(params[:id])

    @order.delivered!
  end

  def rollback
    @order = Order.find(params[:id])

    if @order.delivered?
      @order.ready!
    elsif @order.ready!
      @order.preparing!
    end
  end

  def spotlight
    order = Order.new(number: order_params[:number], color: order_params[:color])
    order.spotlight
  end

  private

  def order_params
    params.require(:order).permit(:number, :color, :tyholt, :pina, :mojito)
  end
end
