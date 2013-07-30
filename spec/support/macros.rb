def set_current_user(current_user=nil)
  user = current_user || Fabricate(:user)
  session[:user_id] = user
end

def set_admin_user(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def current_user
  User.find(session[:user_id])
end

def sign_in(account=nil)
  user = account || Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def visit_video(video)
  visit root_path
  find("a[href='/videos/#{video.id}']").click
end
