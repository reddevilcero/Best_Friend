class Stats
  
  def initialize(hash)
    self.dynamic_attr(hash)

  end

  def dynamic_attr(attributes)
    attributes.each do |attribute_key, attribute_value|
      # here we create in a dynamic way a the setter
      attribute_key = attribute_key.downcase.split(' ').join('_')
      self.class.send(:define_method, "#{attribute_key}=") do |value|
        instance_variable_set("@#{attribute_key}", value)
      end
      # here we create in a dynamic way the getter
      self.class.send(:define_method, attribute_key) do
        instance_variable_get("@#{attribute_key}")
      end
      self.send("#{attribute_key}=", attribute_value)
    end
  end
end