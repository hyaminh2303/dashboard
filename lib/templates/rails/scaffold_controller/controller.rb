<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  def index
    @title = I18n.translate('views.<%= plural_table_name %>.index.title')
    @grid = <%= plural_table_name.titleize %>Grid.new(params[:<%= plural_table_name %>_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET <%= route_url %>/1
  def show
    @title = I18n.translate('views.<%= plural_table_name %>.show.title')
  end

  # GET <%= route_url %>/new
  def new
    @title = I18n.translate('views.<%= plural_table_name %>.new.title')
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
    @title = I18n.translate('views.<%= plural_table_name %>.edit.title')
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.<%= singular_table_name %>.name'))
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to @<%= singular_table_name %>, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.<%= singular_table_name %>.name'))
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.<%= singular_table_name %>.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    end
end
<% end -%>
