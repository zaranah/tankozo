module SignInSupport
  def sign_in_support(user)
    visit new_user_session_path
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
  end
end
