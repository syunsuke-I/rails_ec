# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_Item, only: %i[show edit update destroy]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])
  end
  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit; end

  # POST /items or /items.json
  def create
    @item = Item.new(permit_params)
    @item.save
    redirect_to @item
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @Item.update(Item_params)
        format.html { redirect_to Item_url(@Item), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @Item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @Item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @Item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_Item
    @Item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permit_params
     pp :image
     params.require(:item).permit(:name, :description, :image,:price)
  end
end
