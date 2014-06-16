class MateStockController < ApplicationController
  
  def index
  	@mateStock = MateStock.find(:all)

	  respond_to do |format|
    format.html
    format.json{
      render :json => @mateStock
    }
  end
  end

end
