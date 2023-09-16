# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_Item, only: %i[show edit update destroy]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show; end

  # GET /items/new
  def new
    @Item = Item.new
  end

  # GET /items/1/edit
  def edit; end

  # POST /items or /items.json
  def create
    @Item = Item.new(Item_params)

    respond_to do |format|
      if @Item.save
        format.html { redirect_to Item_url(@Item), notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @Item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @Item.errors, status: :unprocessable_entity }
      end
    end
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
  def Item_params
    params.require(:Item).permit(:title, :description, :status)
  end
end
