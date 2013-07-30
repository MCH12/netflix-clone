require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home for authenticated users" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end

    it "renders new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid info" do
      before do
        post :create, email: Fabricate(:user).email, password: Fabricate(:user).password
      end

      it "sets user in session" do
        expect(session[:user_id]).to_not be_nil
      end

      it "redirects to home page" do
        expect(response).to redirect_to root_path
      end

      it "sets success notice" do
        expect(flash[:success]).to_not be_blank
      end
    end

    context "with invalid info" do
      before do
        post :create
      end

      it "does not set user in session" do
        expect(session[:user_id]).to be_blank
      end

      it "redirects to login" do
        expect(response).to redirect_to login_path
      end
      it "sets error" do
        expect(flash[:error]).to_not be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      set_current_user
      get :destroy
    end

    it "clears user from session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to home" do
      expect(response).to redirect_to root_path
    end

    it "sets notice" do
      expect(flash[:notice]).to_not be_blank
    end
  end
end
