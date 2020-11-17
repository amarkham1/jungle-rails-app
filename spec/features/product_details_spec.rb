require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They can click on a product" do
    # ACT
    visit root_path
    page.all('.actions').first.click_link 'Details'
    # DEBUG / VERIFY

    save_and_open_screenshot
    expect(page).to have_content 'Description'
  end
end
