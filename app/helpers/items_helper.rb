module ItemsHelper
  require 'amazon/aws'
  require 'amazon/aws/search'
  include Amazon::AWS
  include Amazon::AWS::Search    
  
  
  def ad_builder(lookup_item)
    is = ItemSearch.new( 'All', { 'Keywords' => lookup_item } )
    rg = ResponseGroup.new( 'Medium' )
    req = Request.new
    req.locale = 'us'
    resp = req.search( is, rg ) 
    amaz_items = resp.item_search_response.items.item
    @amazon_list = []
  
    @attrib_group = {}      
      amaz_items.each do |item|
        attribs = item.item_attributes
        unless attribs.list_price.nil? 
          unless item.small_image.nil?
          @attrib_group ={
            'title' => attribs.title,
            'price' => attribs.list_price.formatted_price,
            'url' => item.detail_page_url,
            'pic' => item.small_image.url  
           }
          @amazon_list  << @attrib_group
          end
        end
      end  
  end
end
