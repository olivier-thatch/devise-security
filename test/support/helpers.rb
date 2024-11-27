# frozen_string_literal: true

require 'active_support/test_case'

module ActiveSupport
  class TestCase
    mattr_accessor :email_count
    def generate_unique_username
      self.class.email_count ||= 0
      self.class.email_count += 1
      "test#{self.class.email_count}"
    end

    def generate_unique_email
      "#{generate_unique_username}@example.com"
    end

    def with_deprecation_behavior(behavior)
      rails_71_and_up = Gem::Version.new(Rails.version) >= Gem::Version.new('7.1')
      if rails_71_and_up
        old_behavior = Rails.application.deprecators[DEVISE_ORM].behavior
        Rails.application.deprecators.behavior = behavior
      else
        old_behavior = ActiveSupport::Deprecation.behavior
        ActiveSupport::Deprecation.behavior = behavior
      end

      begin
        yield
      ensure
        if rails_71_and_up
          Rails.application.deprecators.behavior = old_behavior
        else
          ActiveSupport::Deprecation.behavior = old_behavior
        end
      end
    end
  end
end
