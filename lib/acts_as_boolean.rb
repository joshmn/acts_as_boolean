require "acts_as_boolean/railtie"

module ActsAsBoolean
  mattr_accessor :timeish, default: -> { Time.current }
  mattr_accessor :normalize_column, default: -> (str) { str.to_s.delete_suffix("_at") }

  module Extension
    def acts_as_boolean(column_name, options = {})
      options[:as] ||= ActsAsBoolean.normalize_column.call(column_name)
      options[:time] ||= ActsAsBoolean.timeish
      define_booleany_reader(column_name, options[:as], options[:time]) unless options[:reader]
      define_booleany_writer(column_name, options[:as], options[:time]) unless options[:writer]
      define_booleany_scope(column_name, options[:as], options[:time]) unless options[:scope]
    end

    def define_booleany_reader(original_column, booleany_column, time)
      define_method("#{booleany_column}") do
        return false if send(original_column).nil?
        send(original_column) <= time.call
      end
      alias_method "#{booleany_column}?", booleany_column
    end

    def define_booleany_writer(original_column, booleany_column, time)
      define_method("#{booleany_column}=") do |value|
        if ActiveModel::Type::Boolean::FALSE_VALUES.exclude?(value)
          send("#{original_column}=", time.call)
        else
          send("#{original_column}=", nil)
        end
      end
    end

    def define_booleany_scope(original_column, booleany_column, time)
      scope booleany_column.to_sym, -> { where("#{original_column} <= ?", time.call).where.not(original_column.to_sym => nil) }
    end
  end
end
