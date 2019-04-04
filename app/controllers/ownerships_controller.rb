class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])
    
    unless @item.persisted?
    # @itemが保存されていない場合、先に@itemを保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
    
      @item = Item.new(read(results.first))
      @item.save
    end
    
    # wantとして保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品をWantしました'
      # haveとして保存
    end
    
    if params[:type] == 'Have'
      current_user.have(@item)
      flash[:success] = '商品をHaveしました'
    end 
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    if params[:type] == 'Want'
      current_user.unwant(@item)
      flash[:success] = '商品のWantを解除しました'
    end
      # haveした商品を解除
    if params[:type] == 'Have'
      current_user.unhave(@item)
      flash[:success] = '商品のHaveを解除しました'
    end
    
    redirect_back(fallback_location: root_path)
  end
end
