require 'rails_helper'

RSpec.describe "books/show", type: :view do
  let(:book) { create(:book) }

  before do
    assign(:book, book)
    render
  end

  it 'has a book title' do
    expect(rendered).to have_css 'h2', text: book.title
  end

  it 'has a book price' do
    expect(rendered).to have_content book.price
  end

  it 'has a book description' do
    expect(rendered).to have_content book.description
  end

  it 'has a book author' do
    expect(rendered).to have_content book.author.full_name
  end
end