require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe "GET #new" do
    before do
      user = 'admin'
      password = 'pw'
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
      get :new
    end

    it "responds successfully" do
      expect(response).to be_successful
    end

    it "returns a 200 response" do
      expect(response).to have_http_status(200)
    end

    it "includes '新しいアイテムを作成'" do
      expect(response.body).to include ""
    end

    it "creates an item with price and stock nil" do
      post items_path, params: { item: { name: "New Item", price: "", stock: "" } }
      expect(response).to redirect_to(item_path(assigns(:item)))
      follow_redirect!

      created_item = Item.last
      expect(created_item.price).to be_nil
      expect(created_item.stock).to be_nil
    end

    it "assigns @img_full_name as '未選択'" do
      expect(assigns(:img_full_name)).to eq '未選択'
    end
  end
end
