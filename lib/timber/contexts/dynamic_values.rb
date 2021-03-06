require "bigdecimal"
require "date"

module Timber
  module Contexts
    class DynamicValues
      class UnrecognizedObjectTypeError < StandardError; end

      include Patterns::ToJSON

      BOOLEAN_TYPES = [FalseClass, TrueClass].freeze
      DATE_TYPES    = [Date, Time].freeze
      FLOAT_TYPES   = [BigDecimal, Float].freeze
      INTEGER_TYPES = [Fixnum].freeze
      NIL_TYPES     = [NilClass].freeze
      STRING_TYPES  = [String].freeze

      def initialize(values_array = nil)
        @values_array = values_array
      end

      private
        def json_payload
          @json_payload ||= values_array.collect do |value|
            to_item(value)
          end
        end

        def to_item(value)
          {
            :name  => value[:name],
            :type  => type(value[:value]),
            :value => value[:value]
          }
        end

        def type(value)
          # Using is_a? because it checks the entire hierarchy, unlike a case statement.
          if BOOLEAN_TYPES.any? { |type| value.is_a?(type) }
            APISettings::BOOLEAN_TYPE
          elsif DATE_TYPES.any? { |type| value.is_a?(type) }
            APISettings::DATE_TYPE
          elsif FLOAT_TYPES.any? { |type| value.is_a?(type) }
            APISettings::FLOAT_TYPE
          elsif INTEGER_TYPES.any? { |type| value.is_a?(type) }
            APISettings::INTEGER_TYPE
          elsif NIL_TYPES.any? { |type| value.is_a?(type) }
            APISettings::NIL_TYPE
          else
            APISettings::STRING_TYPE
          end
        end

        def values_array
          @values_array
        end
    end
  end
end
