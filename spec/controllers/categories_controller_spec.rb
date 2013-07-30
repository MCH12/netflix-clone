require 'spec_helper'

describe CategoriesController do
  before { set_current_user }
  let(:category) { Fabricate(:category) }

  describe "GET index" do
    before { get :index }
    it "sets @categories" do
      expect(assigns(:categories)).to match_array(Category.all)
    end

    it_behaves_like "require_user" do
      let(:action) { get :index }
    end
  end

  describe "GET show" do
    before { get :show, id: category }
    it "sets @category" do
      expect(assigns(:category)).to eq(category)
    end

    it_behaves_like "require_user" do
      let(:action) { get :show, id: category }
    end
  end
end
