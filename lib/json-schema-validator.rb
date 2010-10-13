$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module JsonSchemaValidator
  VERSION = '0.0.2'
end

require 'rubygems'
require 'active_support/core_ext/hash'

class Hash
  # Options:
  # :type - class of key/value
  # :in - array of possible values
  # :format - regexp. only for String type
  # :required - Boolean. if true validation will failed unless a key
  # :if - extra condition. hardcoded for specific path present
  # Sample:
  # reqs = [['requirements.drivers_license.types', {:type => Integer, :in => (1..15).to_a, :format => //, :required => boolean, :if => [['present?(requirements.drivers_license.types)', {any_conditions}]}]]
  # {:requirements => {:drivers_license => {:types => 1}}}.valid?(reqs)
  def valid?(requirements)
    recursive_symbolize_keys! # prepare
    
    valid = false
    requirements.each{|r| valid = key_valid?(*r)}
    valid
  end

  def key_valid?(string_or_array, options={})
    options = {:required => false}.merge(options)
    
    if string_or_array.is_a?(String)
      string_or_array = string_or_array.split('.').collect(&:to_sym)

      if options[:if].is_a?(Array)
        # present?(location_type) -> location_type
        condition_path = options[:if][0].match(/^present\?\((.*)\)$/)[1].split('.').collect(&:to_sym)
        is_path_present = true

        finder = lambda{|object, key|
          next_key = condition_path.slice!(0)
          if next_key and !object[key].try(:has_key?, next_key)
            is_path_present = false
          else
            finder.call(object.try(:[], key), next_key)
          end if object.is_a?(Hash)
        }
        finder.call(self, condition_path.slice!(0))

        options.merge!(options[:if][1]) if is_path_present
      end
    end

    key = string_or_array.slice!(0)
    return options[:required] ? false : true unless self[key]
    return self[key].key_valid?(string_or_array, options) if string_or_array.any?

    return true if options[:required] == false and !self[key]

    result = true
    result = result && options[:in].include?(self[key]) if options[:in]
    result = result && self[key] =~ options[:format]    if options[:format] and self[key].is_a?(String)
    result = result && self[key].is_a?(options[:type])  if options[:type]
    
    result
  end

  def recursive_symbolize_keys!
    symbolize_keys!
    # symbolize each hash in .values
    values.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    # symbolize each hash inside an array in .values
    values.select{|v| v.is_a?(Array) }.flatten.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    self
  end
end
