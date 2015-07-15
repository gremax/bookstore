require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to buy books
  As as a user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',    with: 'wrong_user@example.com'
      fill_in 'Password', with: '12345678'
    end
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end