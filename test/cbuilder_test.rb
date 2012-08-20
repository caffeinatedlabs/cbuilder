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

  test "multiple keys" do
    csv = Cbuilder.encode do |csv|
      csv.title "hello"
      csv.content "world"
    end
    
    CSV.parse(csv).tap do |parsed|
      assert_equal ["title", "content"], parsed[0]
      assert_equal ["hello", "world"], parsed[1]
    end
  end
  
  test "dynamically set a key/value" do
    csv = Cbuilder.encode do |csv|
      csv.set!("Never gonna", "give you up")
    end
    
    assert_equal ["Never gonna"], CSV.parse(csv)[0]
    assert_equal ["give you up"], CSV.parse(csv)[1]
  end

  test "iterates over all values of a passed collection" do
    comments = [ Struct.new(:content, :id).new("hello", 1), Struct.new(:content, :id).new("world", 2) ]

    csv = Cbuilder.encode(comments) do |csv|
      csv.id        :id
      csv.content   :content
    end
    
    assert_equal ["id", "content"], CSV.parse(csv)[0]
    assert_equal ["1", "hello"], CSV.parse(csv)[1]
    assert_equal ["2", "world"], CSV.parse(csv)[2]
  end

  test "with no arguments" do
    comments = [ Struct.new(:content, :id).new("hello", 1), Struct.new(:content, :id).new("world", 2) ]

    csv = Cbuilder.encode(comments) do |csv|
      csv.id        
      csv.content 
    end
    
    assert_equal ["id", "content"], CSV.parse(csv)[0]
    assert_equal ["1", "hello"], CSV.parse(csv)[1]
    assert_equal ["2", "world"], CSV.parse(csv)[2]
  end

  test "nesting multiple children from array" do
    comments = [ Struct.new(:content, :id).new("hello", 1), Struct.new(:content, :id).new("world", 2) ]
    
    csv = Cbuilder.encode do |csv|
      csv.comments comments, :content
    end
    
    CSV.parse(csv).tap do |parsed|
      assert_equal ["comments"], parsed[0]
      assert_equal "hello, world", parsed[1].first
    end
  end
  
  test "nesting multiple children from array when child array is empty" do
    comments = []
    
    csv = Cbuilder.encode do |csv|
      csv.name "Parent"
      csv.comments comments, :content
    end
    
    CSV.parse(csv).tap do |parsed|
      assert_equal "Parent", parsed[1].first
      assert_equal "", parsed[1].second
    end
  end

  test "column sugar" do
    comments = [ Struct.new(:content, :id).new("hello", 1), Struct.new(:content, :id).new("world", 2) ]

    csv = Cbuilder.encode(comments) do |csv|
      csv.column  "Comment ID", :id
      csv.column  "Content",    :content
    end
    
    assert_equal ["Comment ID", "Content"], CSV.parse(csv)[0]
    assert_equal ["1", "hello"], CSV.parse(csv)[1]
    assert_equal ["2", "world"], CSV.parse(csv)[2]
  end

  test "helper method integration" do
    comments = [ Struct.new(:content, :id).new("hello", 1), Struct.new(:content, :id).new("world", 2) ]

    def id_plus_one(comment)
      comment.id + 1
    end

    csv = Cbuilder.encode(comments) do |csv|
      csv.column  "Comment ID", id_plus_one
      csv.column  "Content",    :content
    end
    
    assert_equal ["Comment ID", "Content"], CSV.parse(csv)[0]
    assert_equal ["2", "hello"], CSV.parse(csv)[1]
    assert_equal ["3", "world"], CSV.parse(csv)[2]

  end

end