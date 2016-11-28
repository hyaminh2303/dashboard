namespace :permission do
  desc 'Loading all models and their related controller methods in permissions table.'
  task(:generate => :environment) do
    arr = []
    #load all the controllers
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        #check if the controller is valid
        arr << entry.camelize.gsub('.rb', '').constantize
      elsif entry =~ /^[a-z]*$/ #namescoped controllers
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/
            arr << "#{entry.titleize}::#{x.camelize.gsub('.rb', '')}".constantize
          end
        end
      end
    end

    arr -= [AdvertisersController, LocationListsController, PublishersController]

    arr.each do |controller|
      #only that controller which represents a model
      if controller.permission
        #create a universal permission for that model. eg "manage User" will allow all actions on User model.
        write_permission(controller.permission, 'manage', 'manage') #add permission to do CRUD for every model.
        controller.action_methods.each do |method|
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
            name, cancan_action, desc = eval_cancan_action(method)
            write_permission(controller.permission, cancan_action, name, desc)
          end
        end
      end
    end

    # update role permission PBI 54
    role_agency = Role.find_by_name('Agency')
    return if role_agency.nil?
    role_agency.update!({"name"=>"Agency", "permission_ids"=>["46"]})
  end
end

#this method returns the cancan action for the action passed.
def eval_cancan_action(action)
  case action.to_s
    when 'index'
      name = 'list'
      cancan_action = 'index'
      action_desc = 'list'
    when 'new', 'create'
      name = 'create and update'
      cancan_action = 'create'
      action_desc = 'create'
    when 'show'
      name = 'view'
      cancan_action = 'view'
      action_desc = 'view'
    when 'edit', 'update'
      name = 'create and update'
      cancan_action = 'update'
      action_desc = 'update'
    when 'delete', 'destroy'
      name = 'delete'
      cancan_action = 'destroy'
      action_desc = 'destroy'
    else
      name = action.to_s
      cancan_action = action.to_s
      action_desc = "Other: #{cancan_action}"
  end
  return name, cancan_action, action_desc
end

#check if the permission is present else add a new one.
def write_permission(model, cancan_action, name, desc = 'manage')
  permission = Permission.where(subject_class: model, action: cancan_action).first
  unless permission
    permission = Permission.new
    permission.name = name
    permission.subject_class = model
    permission.action = cancan_action
    permission.description = desc
    permission.save
  end
end