# coding: utf-8
module ActiveModelBase
  extend ActiveSupport::Concern
  include CustomValidators
  # 呼び元のクラスメソッドにするメソッド
  module ClassMethods
    # USE Column.value_to_boolean
    include ActiveRecord::ConnectionAdapters

    # setter cast as integer
    def type_int(*instances)
      instances.each do |instance|
        # over_ride attr_accessor's setter_method
        define_method("#{instance}=") do |val|
          self.instance_variable_set("@#{instance}", if val.blank? then nil else val.to_i end)
        end
      end
    end

    # setter cast as Date
    def type_date(*instances)
      instances.each do |instance|
        # over_ride attr_accessor's setter_method
        define_method("#{instance}=") do |val|
          self.instance_variable_set("@#{instance}", if val.blank? then nil elsif(val.class == Date) then val else Date.parse(val) end)
        end
      end
    end

    # setter cast as boolean
    # only [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'] => true
    # else false
    def type_bool(*instances)
      instances.each do |instance|
        # over_ride attr_accessor's setter_method
        define_method("#{instance}=") do |val|
          self.instance_variable_set("@#{instance}", ActiveRecord::Type::Boolean.new.cast(val))
        end
      end
    end

    # define setter, getter and attributes=
    # usable f.association method in form_for
    def has_many(name, opts = {})
      class_name =
        if opts[:class_name]
          opts[:class_name].to_s
        else
          name.to_s.classify
        end
      class_eval <<EOB
    attr_reader :#{name}
    def #{name}_attributes=(attributes)
      @#{name} ||= []
      attributes.each do |params|
        @#{name}.push(#{class_name}.new(params))
      end
    end
EOB
      define_method("#{name}=") do |val|
        if val.is_a? Array
          val.delete ""
          self.instance_variable_set("@#{name}", val.map(&:to_i))
        else
          raise ActiveRecord::AssociationTypeMismatch
        end
      end
    end

  end

  def attributes
    attrs = {}
    instance_variable_names.each{ |instance_name|
      instance_name.delete!("@")
      key = instance_name.to_sym
      value = self.send(instance_name)
      attrs[key] = value
    }
    attrs
  end

  def attributes=(attrs)
    attrs.each{ |key, val|
      self.send("#{key}=", val)
    }
  end

  def [](attr)
    self.try(attr)
  end

  def []=(attr,value)
    self.try("#{attr}=", value)
  end
end