# frozen_string_literal: true

module Services
  module User
    # Orchestrate all required steps to allow an User to report other User as infected
    class ReportInfectedService
      attr_reader :errors

      def initialize(suspect:, reporter:)
        @suspect = suspect
        @reporter = reporter
        @errors = {}
      end

      def call
        valid? && InfectedUserReport.create(suspect:, reporter:)
      end

      def error_messages
        result = @errors.map do |attr, message|
          "#{attr.capitalize}: #{message}"
        end
        result.join(', ')
      end

      private

      attr_reader :user, :suspect, :reporter

      def valid?
        errors[:suspect] ||= 'Should not be blank' and return false if suspect.blank?
        errors[:reporter] ||= 'Should not be blank' and return false if reporter.blank?
        errors[:suspect] ||= 'Does not exist' and return false unless suspect.persisted?
        errors[:reporter] ||= 'Does not exist' and return false unless reporter.persisted?

        true
      end
    end
  end
end
