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


  # PUT /news/1
  # PUT /news/1.json
  def update
    @mateStock = MateStock.find(params[:id])

    respond_to do |format|
      if @mateStock.update_attributes(params[:mate_stock])
        format.html { redirect_to action: 'index', notice: 'Mate Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mateStock.errors, status: :unprocessable_entity }
      end
    end
  end

end
