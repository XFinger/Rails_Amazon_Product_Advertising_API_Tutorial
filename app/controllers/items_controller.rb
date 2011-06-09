class ItemsController < ApplicationController
  
after_filter :check_with_amazon, :only => [:create, :update]
#  require 'amazon/aws'
#  require 'amazon/aws/search'
  include Amazon::AWS
  include Amazon::AWS::Search  
  def check_with_amazon   
     @check=@item.name
      begin
        is = ItemSearch.new( 'All', { 'Keywords' => @check } )
        rg = ResponseGroup.new( 'Medium' )
        req = Request.new
        req.locale = 'us'
        resp = req.search( is, rg ) 
        items = resp.item_search_response.items.item   
      rescue  
        if Amazon::AWS::Error 
          @item.flag = 'true'
          @item.save
        end  
      end         
  end  
  
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to @item
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      @item.flag = false
      @item.save
      flash[:notice] = "Successfully updated item."
      redirect_to @item
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to items_url
  end
end
