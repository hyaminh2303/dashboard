# The highest role with all the permissions.
if Role.where(super_admin: true).first.nil?
  Role.create!(name: 'Super Administrator', super_admin: true, system_role: true, key: "super_admin")
end

# Universal permission
subject_class_all = 'all'
action_manage = 'manage'
if Permission.where(subject_class: subject_class_all, action: action_manage).first.nil?
  Permission.create!(name: 'Administration Access', subject_class: subject_class_all, action: action_manage, description: 'Can manage everything in system')
end

#assign super admin the permission to manage all the models and controllers
super_admin_role = Role.where(super_admin: true).first
super_admin_role.permissions = [Permission.where(subject_class: subject_class_all, action: action_manage).first]


#other roles
admin_role = Role.find_by(name: 'Administrator')
if admin_role.nil?
  admin_role = Role.create!(name: 'Administrator', key: "admin")
end

agency_role = Role.find_by(name: 'Agency')
if agency_role.nil?
  agency_role = Role.create!(name: 'Agency', system_role: true, key: "agency")
end

# create a user and assign the super admin role to him.
user = User.new(:name => 'Super Administrator', :email => 'admin@yoose.com', :password => 'password', :password_confirmation => 'password')
user.role = super_admin_role
user.save! if user.valid?

# create a user and assign the super admin role to him.
user = User.new(:name => 'Administrator', :email => 'ops@yoose.com', :password => 'password', :password_confirmation => 'password')
user.role = admin_role
user.save! if user.valid?


#assign manage permission to manage all models except User & Role for Administrator role
Role.where(name: 'Administrator').first.permissions = Permission.where(action: action_manage).where.not(subject_class: %w(all User Role))

