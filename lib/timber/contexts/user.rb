module Timber
  module Contexts
    class User < Context
      ROOT_KEY = :user.freeze
      VERSION = 1.freeze

      attr_reader :user

      def email
        return @email if defined?(@email)
        @email = user.respond_to?(:email) ? user.email : nil
      end

      def id
        return @id if defined?(@id)
        @id = user.respond_to?(:id) ? user.id : nil
      end

      def name
        return @name if defined?(@name)
        @name = user.respond_to?(:name) ? user.name : nil
      end

      def valid?
        !user.nil?
      end

      private
        def json_payload
          @json_payload ||= Macros::DeepMerger.merge({
            # order is relevant for logfmt styling
            :id => id,
            :name => name,
            :email => email
          }, super).freeze
        end
    end
  end
end
