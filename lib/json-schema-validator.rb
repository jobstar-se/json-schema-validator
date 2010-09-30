$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module JsonSchemaValidator
  VERSION = '0.0.1'
end

class Hash
  # reqs = [['requirements.drivers_license.types', {:class_name => Integer, :in => (1..15).to_a, :format => //, :required => boolean}]]
  # {:requirements => {:drivers_license => {:types => 1}}}.valid?(reqs)
  def valid?(requirements)
    valid = false
    requirements.each{|r| valid = key_valid?(*r)}
    valid
  end

  # add :required
  def key_valid?(string_or_array, options={})
    options = {:required => false}.merge(options)
    
    if string_or_array.is_a?(String)
      string_or_array = string_or_array.split('.').collect{|s| s.to_sym}
    end

    key = string_or_array.slice!(0)
    return options[:required] ? false : true unless self[key]
    return self[key].key_valid?(string_or_array, options) if string_or_array.any?

    return true if options[:required] == false and !self[key]

    return options[:in].include?(self[key]) if options[:in]
    return self[key] =~ options[:format]    if options[:format]

    self[key].is_a?(options[:class_name])
  end
end
