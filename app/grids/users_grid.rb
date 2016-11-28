class UsersGrid

  include Datagrid

  scope do
    User.joins(:role).merge(Role.where(super_admin: false))
  end

  filter(:name, :string)
  filter(:email, :string)

  column(:name)
  column(:email, html: true) do |model|
    mail_to model.email
  end
  column(:role, html: true) do |model|
    link_to model.role.name, role_path(model.role)
  end
  column(:created_at) do |model|
    model.created_at.to_date
  end

  column(:actions, :html => true) do |model|
    render :partial => 'users/actions', :locals => {:model => model}
  end
end
