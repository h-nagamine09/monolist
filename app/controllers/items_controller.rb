class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
  
  def new
    # @itemsを空の配列として初期化。@itemsに値が入るのは検索ワードが入力された時だけのため。
    @items = []
    
    # フォームから送信される検索ワードを取得
    @keyword = params[:keyword]
    if @keyword.present?
      # 楽天APIを利用して検索を実行。検索結果がResultに代入される
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      
      results.each do |result|
        # 扱いやすいようにItemとしてインスタンスを作成する（保存はしない）
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end 
    end
  end 
  
  private
  
  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128','')
    
    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
