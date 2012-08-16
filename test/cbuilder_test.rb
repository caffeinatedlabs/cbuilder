require 'test/unit'
require 'active_support/test_case'

require 'cbuilder'

class CbuilderTest < ActiveSupport::TestCase
  test "single key" do
    csv = Cbuilder.encode do |csv|
      csv.username "joe_schmo"
    end
    
    assert_equal ["joe_schmo"], CSV.parse(csv)[1]
  end

  test "single key with false value" do
    csv = Cbuilder.encode do |csv|
      csv.is_hacker_news_worthwhile false
    end

    assert_equal ["false"], CSV.parse(csv)[1]
  end

  test "single key with nil value" do
    csv = Cbuilder.encode do |csv|
      csv.username nil
    end

    assert CSV.parse(csv)[0] == ["username"]
    assert_equal [], CSV.parse(csv)[1]
  end
end