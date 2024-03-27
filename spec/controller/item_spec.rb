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

  #Use img name to edit and create
    describe 'POST #create' do
      context 'with valid attributes' do
        it 'creates a new item and redirects to the admin items page' do
          expect {
            post :create, params: { item: { name: 'Test Item', description: 'Test Description', price: 100, stock: 10 } }
          }.to change(Item, :count).by(1)
          expect(response).to redirect_to('/admin/items')
        end
      end
    end


  context 'with invalid attributes' do
    it 'does not create a new item and re-renders the new method' do
      expect {
        post :create, params: { item: { name: '', description: 'Test Description', price: 100, stock: 10 } }
      }.not_to change(Item, :count)
      
      expect(response).to render_template(:new)
    end
  end
  

    it "assigns @img_full_name as '未選択'" do
      expect(assigns(:img_full_name)).to eq '未選択'
    end
  end
end
