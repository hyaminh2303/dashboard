class BannerSizesGrid
  include Datagrid

  scope do
    BannerSize
  end

  filter(:name, :string)
  filter(:size, :string)

  column(:name)
  column(:size)

  column(:actions, :html => true) do |model|
    render :partial => 'banner_sizes/actions', :locals => {:model => model}
  end
end
