require 'test/unit'
require 'active_support/test_case'

require 'cbuilder'

class CbuilderTest < ActiveSupport::TestCase

  @@orders = [
              Struct.new(:number, :name).new(1138, 'Joe Schmo'),
              Struct.new(:number, :name).new(6875309, 'Nate Berkopec')
            ]

  test "single column" do
    csv = Cbuilder.encode do |csv|
      csv.set_collection!(@@orders) do |order|
        csv.col 'Order Number', order.number
      end
    end

    assert_equal ["Order Number"], CSV.parse(csv)[0]
    assert_equal ["1138"], CSV.parse(csv)[1]
  end

  test "single col with nil value" do
    csv = Cbuilder.encode do |csv|
      csv.set_collection!(@@orders) do |order|
        csv.col 'Order Number', nil
      end
    end

    assert CSV.parse(csv)[0] == ["Order Number"]
    assert_equal [], CSV.parse(csv)[1]
  end

  test "multiple cols" do
    csv = Cbuilder.encode do |csv|
      csv.set_collection!(@@orders) do |order|
        csv.col "Order Number",  order.number 
        csv.col "Name",          order.name
      end
    end
    
    CSV.parse(csv).tap do |parsed|
      assert_equal ["1138", "Joe Schmo"], parsed[1]
      assert_equal ["6875309", "Nate Berkopec"], parsed[2]
    end
  end

  test "protects commas" do
    orders = [Struct.new(:number, :name).new(1138, 'Joe, Schmo')]
    csv = Cbuilder.encode do |csv|
      csv.set_collection!(orders) do |order|
        csv.col "Name", order.name
      end
    end

    assert_equal ["Joe, Schmo"], CSV.parse(csv)[1]
  end

  test "escaping quotes" do
    orders = [Struct.new(:number, :name).new(1138, %{"Joe Schmo"})]
    csv = Cbuilder.encode do |csv|
      csv.set_collection!(orders) do |order|
        csv.col "Name", order.name
      end
    end

    assert_equal [%{"Joe Schmo"}], CSV.parse(csv)[1]
  end

end