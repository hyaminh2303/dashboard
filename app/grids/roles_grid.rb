class RolesGrid

  include Datagrid

  scope do
    Role.where(super_admin: false)
  end

  filter(:name, :string)

  column(:name, html: true) do |model|
    link_to model.name, edit_role_path(model)
  end
  column(:actions, :html => true) do |model|
    render :partial => 'roles/actions', :locals => {:model => model}
  end
end
