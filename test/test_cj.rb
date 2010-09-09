require 'helper'

class TestCj < Test::Unit::TestCase
  def test_retrieve_advertisers
    result = CommissionJunction::Advertiser.find(:keywords => "stuff")
    assert(!result.nil?, "No result")
    assert(result.is_a?(Array), "Result is not an array")
    assert(result.length > 0, "Zero length result")
    assert(result.first.is_a?(CommissionJunction::Advertiser), "Returned wrong object")
  end
  
  def test_retrieve_products
    # it takes quite a combination to find a small set of products
    result = CommissionJunction::Product.find(:keywords => "+orange +pants +hat")
    assert(!result.nil?, "No result")
    assert(result.is_a?(Array), "Result not an array")
    assert(result.length > 0, "Zero length result")
    assert(result.first.is_a?(CommissionJunction::Product), "Returned wrong object")
  end
  
  def test_retrieve_commisions
    # no parameters should render a list from the past two days
    result = CommissionJunction::Commission.find
    assert(!result.nil?, "No result")
    assert(result.is_a?(Array), "Result not an array")
    # will need live data before this test can work
    if result.length > 0
      assert(result.first.is_a?(CommissionJunction::Advertiser), "Returned wrong object")
    end
    
  end
    
end
