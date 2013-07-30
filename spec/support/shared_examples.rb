shared_examples 'require_user' do
  it 'redirects to root path' do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples 'require_admin' do
  it 'redirects to root path' do
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples 'tokenable' do
  it 'generates a random token for object' do
    expect(object.token).to be_present
  end
end
