class User
  class Visitor
    class Interaction < ActiveRecord::Base
      # associations
      belongs_to :campaign
      belongs_to :resource, polymorphic: true
      belongs_to :visitor

      # validations
      validates :campaign, presence: true
      validates :resource, presence: true
      validates :visitor, presence: true
      validates :action,
                presence: true,
                uniqueness: { scope: [:campaign_id, :resource_id, :visitor_id] }
      validate :related_resource
      # definitions
      serialize :data, JSON
      enum action: [:start, :finish]

      protected

      def related_resource
        return if resource.nil? || resource.campaign == campaign
        errors.add(:resource, 'must be related to campaign')
      end
    end
  end
end