# frozen_string_literal: true

# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable.
# *   The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?

class Factory
  class << self
    def new(*args, &block)
      const_set(args.shift.capitalize, class_new(*args, &block)) if args.first.is_a?(String)
      class_new(*args, &block)
    end

    def class_new(*args, &block)
      Class.new do
        attr_accessor(*args)

        define_method :initialize do |*vars|
          raise ArgumentError, "Expected #{args.count} argument(s)" if args.count != vars.count

          args.each_index do |index|
            instance_variable_set("@#{args[index]}", vars[index])
          end
        end

        define_method :args do
          args
        end

        class_eval(&block) if block_given?

        define_method :dig do |*args|
          args.reduce(to_h) do |hash, arg|
            return nil if hash[arg].nil?

            hash[arg]
          end
        end

        define_method :to_h do
          args.zip(values).to_h
        end

        define_method :each do |&block|
          values.each(&block)
        end

        define_method :each_pair do |&pair|
          to_h.each_pair(&pair)
        end

        define_method :length do
          args.size
        end

        define_method :select do |&block|
          values.select(&block)
        end

        define_method :== do |other|
          self.class == other.class && values == other.values
        end

        define_method :values do
          instance_variables.map { |arg| instance_variable_get(arg) }
        end

        define_method :values_at do |*indexes|
          indexes.map { |index| values[index] }
        end

        define_method :[] do |arg|
          arg.is_a?(Integer) ? values[arg] : instance_variable_get("@#{arg}")
        end

        define_method :[]= do |arg, value|
          instance_variable_set("@#{arg}", value)
        end

        alias_method :to_a, :values
        alias_method :size, :length
        alias_method :members, :args
        alias_method :eql?, :==
      end
    end
  end
end
