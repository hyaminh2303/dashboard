class HomeController < ApplicationController
  include ApplicationHelper
  def index
    @grid = StatsGrid.new(stats_params.merge({current_ability: current_ability, agency_can_see_detail_campaign: agency_can_see_detail_campaign?(current_user)}))
  end

  def stats
    period = get_period
    @grid = StatsGrid.new(stats_params.merge(current_ability: current_ability, agency_can_see_detail_campaign: agency_can_see_detail_campaign?(current_user))) do |scope|
      scope.page(page).per(params[:length].to_i).belong_to(current_user).order_with_default(order_field, sort_type).search_name(name_kw)
    end

    if @grid.assets.size > 1
      @total_tracking = Campaign.total_tracking(period).belong_to(current_user).search_name(name_kw)
    end

  end

  private

  def name_kw
    params[:search][:value]
  end

  def order_field
    order_field_index = params[:order]['0'][:column].to_i
    case order_field_index
      when 1
        'name'
      when 2
        'views'
      when 3
        'clicks'
      when 4
        'ROUND((clicks/NULLIF(views,0)),4)'
      else
        nil
    end
  end

  def sort_type
    params[:order]['0'][:dir].upcase
  end

  def page
    (params[:start].to_i / params[:length].to_i) + 1
  end

  def get_period
    if name_kw.present?
      params[:stats_grid][:period] = [2.year.ago.to_date.to_formatted_s, 1.year.since.to_date.to_formatted_s]
    end

    if stats_params.present?
      if stats_params[:period].present? && stats_params[:period].first.present?
        period = stats_params[:period]
        [Date.parse(period[0]), Date.parse(period[1])]
      elsif stats_params[:period_preset].present?
        params[:stats_grid][:period] = Campaign.get_period(stats_params[:period_preset].to_sym)
      end
    else
      [1.week.ago.to_date, Date.today]
    end
  end

  def stats_params
    set_default_period params.fetch(:stats_grid, {}).permit(:period_preset, period: [])
  end

  def set_default_period(stats_params)
    if stats_params[:period].blank? and stats_params[:period_preset].blank?
      if current_user.admin?
        stats_params[:period_preset] = 'last_7_days'
        stats_params[:period]        = [1.week.ago.to_date.to_formatted_s, Date.today.to_formatted_s]
      else
        stats_params[:period_preset] = 'this_month'
        stats_params[:period]        = [Date.today.at_beginning_of_month.to_formatted_s, Date.today.at_end_of_month.to_formatted_s]
      end
    end
    stats_params
  end
end
