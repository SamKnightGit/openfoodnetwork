require 'spec_helper'

feature "As a consumer I want to check out my cart", js: true do
  include AuthenticationWorkflow
  include WebHelper
  include ShopWorkflow
  include UIComponentHelper

  let(:distributor) { create(:distributor_enterprise) }
  let(:supplier) { create(:supplier_enterprise) }
  let!(:order_cycle) { create(:simple_order_cycle, distributors: [distributor], coordinator: create(:distributor_enterprise)) }
  let(:product) { create(:simple_product, supplier: supplier) }
  let(:order) { create(:order, order_cycle: order_cycle, distributor: distributor) }
  let(:user) { create_enterprise_user }

  before do
    set_order order
    add_product_to_cart
  end

  it "does not not render the login form when logged in" do
    quick_login_as user
    visit checkout_path 
    within "section[role='main']" do
      page.should_not have_content "Login"
      page.should have_content "Customer Details"
    end
  end

  it "renders the login buttons when logged out" do
    visit checkout_path 
    within "section[role='main']" do
      page.should have_content "Login"
      click_button "Login"
    end
    page.should have_content "Remember Me"
  end

  it "allows user to checkout as guest" do
    visit checkout_path 
    click_button "Checkout as guest"
    page.should have_content "Customer Details"
  end
end

