require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET #show" do
    it "assigns the requested user to @user" do
      user = create(:user)
      get :show, id:user
      expect(assigns(:user)).to eq(user)
    end
    it "renders the #show view" do
      get :show, id: create(:user)
      expect(response).to render_template :show
    end
  end

end
