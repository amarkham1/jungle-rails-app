require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations" do
    before do
      @category = Category.new(:name => "Apparel")
    end

    it "successfully saves a new product with all four fields set" do
      @product = Product.new(:name => "Test123", :price => 123.3, :quantity => 12, :category => @category)
      @product.save
      expect(Product.all).to include(@product)
    end

    it "fails to save when a new product is missing a name" do
      @product = Product.new(:name => nil, :price => 123.3, :quantity => 12, :category => @category)
      @product.save
      expect(@product.errors.full_messages).to include("Name can't be blank")
      expect(Product.all).not_to include(@product)
    end

    it "fails to save when a new product is missing a price" do
      @product = Product.new(:name => "Test123", :quantity => 12, :category => @category)
      @product.save
      expect(@product.errors.full_messages).to include("Price can't be blank")
      expect(Product.all).not_to include(@product)
    end

    it "fails to save when a new product is missing a quantity" do
      @product = Product.new(:name => "Test123", :price => 123.3, :quantity => nil, :category => @category)
      @product.save
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
      expect(Product.all).not_to include(@product)
    end

    it "fails to save when a new product is missing a category" do
      @product = Product.new(:name => "Test123", :price => 123.3, :quantity => 12, :category => nil)
      @product.save
      expect(@product.errors.full_messages).to include("Category can't be blank")
      expect(Product.all).not_to include(@product)
    end
  end
end
