class Role < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :permissions, join_table: 'roles_permissions'

  validates :name, presence: true

  scope :not_super_admin, -> { where(super_admin: false) }

  class << self
    Role.pluck(:key).each do |key|
      define_method key.to_sym do
        Role.find_by(key: key)
      end
    end
  end

  Role.pluck(:key).each do |key|
    define_method "#{key}?" do
      self.key == key
    end
  end

  def has_permission?(permission)
    permissions.include?(permission)
  end
end
