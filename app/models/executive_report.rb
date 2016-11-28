class ExecutiveReport < Prawn::Document

  COLOR_YOOSE = 'EB0301'
  COLOR_HEADER_BORDER = 'F81919'
  COLOR_TABLE_HEADER = 'C0504D'
  COLOR_ROW_HIGHLIGHT = 'F2DCDB'

  COLOR_TABLE_BODER = '963634'

  COLOR_CAMPAIGN_HEALTH = [
      VERY_GOOD_HEALTH = 'FFEB9C',
      GOOD_HEALTH = 'C6EFCE',
      BAD_HEALTH = 'FFFFFF',
      VERY_BAD_HEALTH = 'FF7859']

  COLORS_CHART = ['5A8FD8', 'EB7A79']

  CHART_BACKGROUND = 'F2F2F2'

  def initialize(opts={})
    super
    self.font_size = 8.5
    @live_campaigns = opts[:live_campaigns]
    @incoming_campaigns = opts[:incoming_campaigns]
    @live_campaigns_by_country = @live_campaigns.group_by{|m| m.country_code}
    @live_campaigns_by_agency = @live_campaigns.group_by{|m| m.agency_name}
  end

  def header_section(title)
    stroke_color COLOR_HEADER_BORDER
    self.line_width = 1
    table [['YOOSE', title]], cell_style: {border_width: 0, height: 40, font_style: :bold, padding: 10}, position: 20 do
      column(0).style(size: 18, text_color: COLOR_YOOSE, width: 100)
      column(1).style(size: 14, align: :center, width: 350)
    end
    move_up 40
    self.line_width = 2
    stroke do
      rounded_rectangle [0, cursor], 540, 35, 15
    end
    move_down 50
  end

  def incoming_campaigns
    data_table = [
        ['Campaign Name', 'Start Date', 'Budget', 'Remark']
    ]

    if @incoming_campaigns.any?
      @incoming_campaigns.each do |m|
        data_table << [m.name, m.active_at.to_formatted_s(), m.actual_budget.format, m.remark]
      end

      draw_table data: data_table, pos: 20, column_widths: [150, 75, 75, 150], has_total_row: false
    else
      text 'There is no incoming campaigns'
    end
  end

  def campaign_health_info(position=170)
    data = [['', 'Campaign Health is above 10%'],
            ['', 'Campaign Health is between 5% and 10%'],
            ['', 'Campaign Health is between -5% and 5%'],
            ['', 'Campaign Health is under -5%']]

    table data, cell_style: { border_color: COLOR_TABLE_BODER, padding: 2, size: 7.5}, position: position do
      COLOR_CAMPAIGN_HEALTH.each_with_index do |c, i|
        column(0).row(i).style( background_color: c, width: 50)
      end
    end
    move_down 15
    if cursor < 290
      start_new_page
    end
  end

  def campaigns_overview

    total_budget = Money.new(0)

    highlight_row_ids = []

    header = ['', 'Media Budget', 'Delivery of Target', 'Campaign Health', 'CTR', 'Total Days', 'Days left', 'CPC/CPM price']

    data_table = [header]

    @live_campaigns_by_country.map do |country_code, campaigns_group|
      data_table << [{content: Country[country_code].name, colspan: 8}]
      highlight_row_ids << data_table.size-1

      campaigns_group.each do |c|
        data_table << [c.name, c.actual_budget.format, "#{c.delivery_realized_percent}%", "#{c.health_percent}%", "#{c.ctr.round(2)}%", c.total_days, c.days_left, c.unit_price_in_usd_as_money.format]
        total_budget += c.actual_budget
      end
    end

    data_table << ['Grand Total', { content: total_budget.format, colspan: 7}]

    column_widths = [140, 70, 75, 70, 40, 45, 40, 60]

    draw_table data: data_table, pos: :left, column_widths: column_widths, highlight_row_ids: highlight_row_ids do |f|
      values = f.cells.column(3).rows(1..-2)

      very_good_health = values.filter { |cell| cell.content.present? and cell.content.to_f >= 10 }

      good_health = values.filter { |cell| cell.content.present? and cell.content.to_f >= 5 and cell.content.to_f < 10 }

      bad_health = values.filter { |cell| cell.content.present? and cell.content.to_f >= -5 and cell.content.to_f < 5 }

      very_bad_health = values.filter { |cell| cell.content.present? and cell.content.to_f < -5 }

      very_good_health.background_color = VERY_GOOD_HEALTH
      good_health.background_color = GOOD_HEALTH
      bad_health.background_color = BAD_HEALTH
      very_bad_health.background_color = VERY_BAD_HEALTH
    end
  end

  def campaign_status(status = 'Live')
    table([['Campaign Status', status]], cell_style: {background_color: COLOR_ROW_HIGHLIGHT, border_width: 0})
    move_down 10
  end

  def campaigns_analytic
    y = cursor

    country_analytic y

    agency_analytic y

    move_down 50
  end

  def country_analytic(y)
    total_budget = Money.new(0)
    country_stats   = []

    @live_campaigns_by_country.map do |country_code, campaigns_group|
      total_budget_by_country = campaigns_group.map{|m| m.actual_budget }.sum
      country_stats << [Country[country_code].name,  total_budget_by_country]
      total_budget += total_budget_by_country
    end
    move_cursor_to y
    draw_stats_chart 'Sales by Country (USD)', country_stats, total_budget, [0, y]
    move_down 10
    draw_stats_table ['Country', 'Total'], country_stats, total_budget.format, [125, 75], 0

  end

  def agency_analytic(y)
    agency_stats   = []
    agency_stats_no_breakdown = []

    total_budget = Money.new(0)

    #
    @live_campaigns_by_agency.map do |agency_name, campaigns_group|
      total_budget_by_agency = campaigns_group.map{|m| m.actual_budget }.sum
      campaigns_group.each do |campaign|
        parent_id = campaign.parent_id
        agency_id = campaign.agency_id
        agency_stats_no_breakdown << [agency_name,  total_budget_by_agency, agency_id, parent_id]
        break
      end
      total_budget += total_budget_by_agency
    end

    agency_stats_no_breakdown.each do |agency_stats_item|
      # if parent id is not nil, look for parent agency and add it to array
      unless agency_stats_item[3].nil?
        # first, check if parent agency is in array yet?
        parent_item = agency_stats_no_breakdown.select{|m| m[2] == agency_stats_item[3]}
        # if not then have to look up in database
        if parent_item.empty?
          parent_agency = Agency.find(agency_stats_item[3].to_i)
          agency_stats_no_breakdown << [parent_agency.name,  Money.new(0), parent_agency.id, nil]
        end
      end
    end

    agency_stats_no_breakdown.each do |agency_stats_item|
      if agency_stats_item[3].nil?
        sub_agency_total = agency_stats_no_breakdown.map { |m|
          if m[3] == agency_stats_item[2]
            m[1]
          else
            Money.new(0)
          end
        }.sum

        agency_stats << [agency_stats_item[0],  sub_agency_total + agency_stats_item[1]]
      end
    end

    move_cursor_to y
    draw_stats_chart 'Sales by Agency (USD)', agency_stats, total_budget, [300, y]
    move_down 10
    draw_stats_table ['Sales Agency', 'Total'], agency_stats, total_budget.format, [125, 75], 300


  end

  private

  def draw_table(*args)
    opts = args.extract_options!

    data = opts[:data]
    position = opts[:pos] || :left
    column_widths = opts[:column_widths] || []
    highlight_row_ids = opts[:highlight_row_ids] || []
    has_total_row = opts.include?(:has_total_row) ? opts[:has_total_row] : true

    table(data, cell_style: {borders: [], border_color: COLOR_TABLE_BODER, padding: 2}, position: position, column_widths: column_widths) do |f|
      f.row(0).style(background_color: COLOR_TABLE_HEADER, text_color: 'FFFFFF', font_style: :bold, size: 7, borders: [:top])
      if has_total_row
        f.row(-1).style(border_width: 1.5, font_style: :bold, borders: [:top, :bottom])
      else
        f.row(-1).style(borders: [:bottom])
      end
      highlight_row_ids.each do |i|
        f.row(i).style(background_color: COLOR_ROW_HIGHLIGHT, font_style: :bold)
      end
      if block_given?
        yield f
      end
    end
    move_down 10
  end

  def pie_graph(title, data, legend, position)
    require 'gchart'
    require 'mechanize'

    mechdata = Mechanize.new

    image_pic = GChart.pie title: title, data: data, legend: legend, colors: COLORS_CHART do |g|
      g.entire_background = CHART_BACKGROUND
      g.chart_background  = CHART_BACKGROUND
    end

    mechdata.get(image_pic.to_url).save! 'tmp/pie_graph.jpg'

    bounding_box(position, width: 200) do
      image 'tmp/pie_graph.jpg', width: 200
      stroke_bounds
    end
  end

  def draw_stats_table(header, data_stats, total_stats, column_widths, pos)
    footer = ['Grand Total', total_stats]

    data_table = [header]
    data_table += data_stats.map{|k, v| [k, v.format]}
    data_table << footer

    draw_table data: data_table, pos: pos, column_widths: column_widths
  end

  def draw_stats_chart(title, data_stats, total_stats, pos)

    data_chart = data_stats.map{|k, v| (v/total_stats*100).round(2)}
    legend = data_stats.map{|k, v| k}

    pie_graph title, data_chart, legend, pos
  end
end