class SubTotalSettingsGrid

  include Datagrid

  scope do
    SubTotalSetting
  end

  filter(:name, :string) do |value|
    self.where('name LIKE ?', "%#{value}%")
  end
  filter(:sub_total_setting_type, :enum, select: {'Fixed' => 0, 'Percent' => 1}, header: "Type")
  filter(:value, :float, header: "Value")

  column(:name)
  column(:type) do |model|
    model.sub_total_setting_type
  end
  column(:value) do |model|
    model.value
  end
  column(:actions, header: '', html: true) do |model|
    render :partial => 'sub_total_settings/actions', :locals => {:model => model}
  end
end
