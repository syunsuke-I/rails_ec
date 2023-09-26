# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update]

  # GET /items
  def index
    @is_admin = request.fullpath.include?('/admin')
    @items = Item.all.page(params[:page]).per(12)
  end

  # GET /items/1
  def show
    items = Item.all
    # 関連に自分自身を表示させないようにするため
    @item = Item.find(params[:id])
    @items_except_myself = items.reject { |item| item.id == @item.id }
    @last_four_items = @items_except_myself[-4..]
  end

  # GET /items/new
  def new
    @item = Item.new
    @img_full_name = '未選択'
    # DB側では初期値0だがnilにして入力欄のplaceholderの文字を見せるため
    @item.price = nil
    @item.stock = nil
  end

  def edit
    @item = Item.find_by(id: [params[:id]])
    set_img_name
  end

  def create
    @item = Item.new(permit_params)
    if @item.save
      redirect_to '/admin/items'
    else
      set_img_name
      render :new
    end
  end

  def update
    @item = Item.find_by(id: [params[:id]])
    if @item.update(permit_params)
      flash[:success] = UPDATE_SUCSESS_MSG
      redirect_to "/admin/items/#{params[:id]}"
    else
      set_img_name
      flash[:danger] = UPDATE_ERROR_MSG
      render :edit
    end
  end

  def destroy
    @item = Item.find_by(id: [params[:id]])
    @item.discard
    redirect_to @item
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Use img name to edit and create
  def set_img_name
    @img_full_name =
      if @item.image.attached?
        img_info = rails_blob_path(@item.image)
        img_extntion = File.extname(img_info).downcase
        img_name = File.basename(img_info, '.*')
        img_name + img_extntion
      else
        '未選択'
      end
  end

  # Only allow a list of trusted parameters through.
  def permit_params
    params.require(:item).permit(:name, :description, :image, :price, :stock)
  end
end