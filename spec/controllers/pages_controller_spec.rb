require 'spec_helper'

describe PagesController do
  it "redirects to videos_path if authenticated user" do
    set_current_user
    get :front
    expect(response).to redirect_to videos_path
  end

  it "renders front if unauthenticated user" do
    expect(response.code).to eq("200")
  end
end
