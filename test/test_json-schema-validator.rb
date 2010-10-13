require File.dirname(__FILE__) + '/test_helper.rb'

class TestJsonSchemaValidator < Test::Unit::TestCase
  def setup
    @int_json_hash = {:requirements =>  {:drivers_license => {:types => 1}}}
    @str_json_hash = {:requirements =>  {:drivers_license => {:types => 'foo'}, :expirience => 5}}
    @arr_json_hash = {:requirements => [{:drivers_license => {:types => 1}}, {:drivers_license => {:types => 2}}]}
  end
  
  def test_class_name
    reqs = [['requirements.drivers_license.types', {:type => Integer}]]
    assert @int_json_hash.valid?(reqs)

    reqs = [['requirements.drivers_license.types', {:type => String}]]
    assert !@int_json_hash.valid?(reqs)
  end

  def test_in
    reqs = [['requirements.drivers_license.types', {:type => Integer, :in => (1..15).to_a}]]
    assert @int_json_hash.valid?(reqs)

    reqs = [['requirements.drivers_license.types', {:type => Integer, :in => (11..15).to_a}]]
    assert !@int_json_hash.valid?(reqs)
  end

  def test_format
    reqs = [['requirements.drivers_license.types', {:type => String, :format => /foo/}]]
    assert @str_json_hash.valid?(reqs)

    reqs = [['requirements.drivers_license.types', {:type => String, :format => /bar/}]]
    assert !@str_json_hash.valid?(reqs)
  end

  def test_required
    reqs = [['requirements.driver_license.wrong_types', {:type => String}]]
    assert @str_json_hash.valid?(reqs)

    reqs = [['requirements.driver_license.wrong_types', {:type => String, :required => true}]]
    assert !@str_json_hash.valid?(reqs)

    reqs = [['requirements.driver_license.types', {:type => String, :required => true}]]
    assert !@str_json_hash.valid?(reqs)
  end

  def test_if
    reqs = [['requirements.expirience', {:type => Integer}]]
    assert @str_json_hash.valid?(reqs)

    reqs = [['foo', {:type => Integer, :if => ['present?(requirements.drivers_license.types)', {:required => true}]}]]
    assert !@str_json_hash.valid?(reqs)
  end
end
