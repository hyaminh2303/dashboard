class Permission < ActiveRecord::Base
  scope :except_all, -> { where.not(subject_class: 'all') }

  def self.grouped
    Rails.cache.fetch(:grouped_permissions) do
      self.except_all.where(action: 'manage').group_by{ |s| s.subject_class }
    end
  end
end
