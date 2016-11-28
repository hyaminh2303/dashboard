module Axlsx

  class WorkPoint
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    # index from 1
    def x_as_index
      x.ord - 'A'.ord + 1
    end
  end

  class WorkRegion
    attr_accessor :x, :y, :w, :h, :columns

    def initialize(params={})
      @x = params[:x]
      @y = params[:y]
      @w = params[:w]
      @h = params[:h]
      @columns = params[:columns]
      left(params[:left]) if params[:left].present?
    end

    def right_bottom
      WorkPoint.new(x_end, y_end)
    end

    def x_by_column(column_name)
      (x.ord + columns.index(column_name)).chr
    end

    # i from 1
    def x_by_index(i)
      (x.ord + i - 1).chr
    end

    def y_by_index(i)
      y + i - 1
    end

    def y_start_body
      y + 2
    end

    def y_body_by_index(i)
      y + i + 1
    end

    # start from body
    def range_by_column(column_name, i_start = 3)
      "#{x_by_column(column_name)}#{i_start}:#{x_by_column(column_name)}#{y_end}"
    end

    def range_at_row(at_row, i_start = 1, i_end = w)
      "#{x_by_index(i_start)}#{y+at_row-1}:#{x_by_index(i_end)}#{y+at_row-1}"
    end

    def all
      "#{x}#{y}:#{x}#{y_end}"
    end

    def left(value)
      @x = x_by_index(value)
    end

    def y_end
      y_by_index(h)
    end

    def x_end
      (x.ord + w - 1).chr
    end
  end

  class WorksheetRender

    attr_internal :workbook, :sheet, :styles, :x, :y

    def initialize(sheet)
      @_workbook = sheet.workbook
      @_sheet = sheet
      @_x = 'A'
      @_y = 1
    end

    def current_row
      @_y
    end

    def styles
      styles = workbook.styles
      sub_bg_color = 'D9D9D9'
      format_number = '#,##0'
      format_money_usd = '[$$-409]#,##0.00;[RED]-[$$-409]#,##0.00'
      format_percent = '0.00%'
      format_short_date = 'dd-mmm'

      if @_styles.nil?
        style_collection = {
            title: {b: true, bg_color: 'FF0000', fg_color: 'FF', :alignment => { :horizontal => :center }},
            blank: {fg_color: 'FF'},
            border: {border: Axlsx::STYLE_THIN_BORDER, :alignment => { :horizontal => :center }},
            border_money: {border: Axlsx::STYLE_THIN_BORDER, format_code: format_money_usd, :alignment => { :horizontal => :center }},

            number: {format_code: format_number},
            money: {format_code: format_money_usd},
            percent: {format_code: format_percent},
            date: {format_code: format_short_date},

            head: {:b => true, :bg_color => "00", :fg_color => "FF"},
            head_number: {:b => true, :bg_color => "00", :fg_color => "FF", :format_code => format_number},
            head_money: {:b => true, :bg_color => "00", :fg_color => "FF", :format_code => format_money_usd},
            head_percent: {:b => true, :bg_color => "00", :fg_color => "FF", :format_code => format_percent},

            sub: {bg_color: sub_bg_color},
            sub_number: {bg_color: sub_bg_color, format_code: format_number},
            sub_money: {bg_color: sub_bg_color, format_code: format_money_usd},
            sub_percent: {bg_color: sub_bg_color, format_code: format_percent},

            bold: {:b => true},
            align_right_bold: {b: true, :alignment => { :horizontal => :right }}
        }

        style_collection[:money_with_bold] = style_collection[:money].merge(style_collection[:bold])

        add_border_to_style_collection(style_collection, [:title, :head, :number, :money, :percent, :date, :bold, :money_with_bold])

        @_styles = Hash[style_collection.map { |k, v| [k, styles.add_style(v)] }]

        color_collection ={
            pie_colors: %w(FF0000 00FF00 0000FF),
        }

        @_styles.merge!(color_collection)
      end
      @_styles
    end

    def add_table(table, parent_region=nil)

      has_parent_region = !parent_region.nil?
      has_sub_rows = !table[:sub_rows].nil?

      current_y = has_parent_region ? parent_region.y : y
      start_x = table[:start_index].nil? ? 1 : table[:start_index].last

      region = WorkRegion.new({x: x,
                               y: current_y,
                               w: table[:col_number].nil? ? table[:data][:columns].length : table[:col_number],
                               h: table[:row_number].nil? ? table[:data][:model].length + 2 : table[:row_number],
                               columns: table[:data][:columns].keys,
                               left: start_x,
                              })

      sheet.merge_cells region.range_at_row(1)

      if has_parent_region
        current_y = add_row_at_position(table[:title], styles[:title_with_border], start_x, current_y)
        current_y = add_row_at_position(table[:head], styles[:head_with_border], start_x, current_y)
      else
        sheet.add_row table[:title], style: styles[:title_with_border]
        sheet.add_row table[:head], style: styles[:head_with_border]
      end

      body_cell_styles = table_body_cell_styles(table)

      index_row = 0
      table[:data][:model].each do |m|
        # Add sub rows on top
        if has_sub_rows and table[:sub_rows][:position] == :top
          result = add_sub_rows index_row, m[:data], table[:sub_rows][:columns], table[:sub_rows][:values], {
                                             region: region,
                                             start_x: start_x,
                                             current_y: current_y,
                                             body_cell_styles: table_body_cell_styles(table, :sub_rows)
                                         }
          index_row = result[:index_row]
          current_y = result[:current_y]
          region.h += result[:h] # increase height of table
        end

        data = table[:data][:columns].map do |attr, s|
          value = table[:data][:values].nil? ? nil : table[:data][:values][attr]
          value.nil? ? m.send(attr) : value.call(region, index_row+1, m)
        end

        if has_parent_region
          current_y = add_row_at_position(data, body_cell_styles, start_x, current_y)
        else
          sheet.add_row data, style: body_cell_styles
        end

        # Add sub rows on bottom
        if has_sub_rows and table[:sub_rows][:position] == :bottom
          result = add_sub_rows index_row, m[:data], table[:sub_rows][:columns], table[:sub_rows][:values], {
                                             region: region,
                                             start_x: start_x,
                                             current_y: current_y,
                                             body_cell_styles: table_body_cell_styles(table, :sub_rows)
                                         }
          index_row = result[:index_row]
          current_y = result[:current_y]
          region.h += result[:h] # increase height of table
        end

        index_row += 1
      end

      yield(sheet, region, index_row) if block_given?

      add_padding_bottom(region, table[:padding_bottom])

      region
    end

    def add_row(data=[], cell_styles=[])
      sheet.add_row data, style: cell_styles.each.map{|s| styles[s]}
    end

    def add_region(width, height)
      height.times.each{ sheet.add_row Array.new(width, nil) }

      WorkRegion.new({x: x,
                      y: y,
                      w: width,
                      h: height,
                     })
    end

    def add_pie_graph_from_region(graph)
      graph.merge!({
           data: "#{graph[:region].x_by_index(2)}#{graph[:region].y_start_body}:#{graph[:region].x_by_index(2)}#{graph[:region].y_end}",
           labels: "#{graph[:region].x}#{graph[:region].y_start_body}:#{graph[:region].x}#{graph[:region].y_end}"
                   })

      add_pie_graph graph
    end

    def add_pie_graph(graph)
      sheet.add_chart(Axlsx::Pie3DChart,
                      start_at: graph[:start_at],
                      end_at: graph[:end_at],
                      title: graph[:title]) do |chart|
        chart.add_series data: sheet[graph[:data]],
                         labels: sheet[graph[:labels]]
                         #colors: graph[:colors].nil? ? styles[:pie_colors] : graph[:colors]

      end
    end

    def column_widths(column_widths)
      column_widths.values.each_with_index { |w, i| sheet.column_info[i].width = w}
    end

    def add_row_at_position(data, cell_styles, x, y)
      data.each_with_index do |value, index_cell|
        row = sheet.rows[y-1]
        style = cell_styles.is_a?(Array) ? cell_styles[index_cell] : cell_styles
        style = styles[style] unless style.is_a?(Integer)
        row.cells[x+index_cell-1] = Axlsx::Cell.new(row, value, {style: style})
        row.cells.pop
      end
      y + 1
    end

    private

    def add_border_to_style_collection(style_collection, styles)
      styles.each do |s|
        s_with_border = "#{s}_with_border".to_sym
        style_collection[s_with_border] = style_collection[s].merge({border: Axlsx::STYLE_THIN_BORDER})
      end
    end

    def table_body_cell_styles(table, key=:data)
      style_names = table[key][:styles].nil? ? table[key][:columns].values : table[key][:styles]
      style_names = style_names.each.map{|s| s.nil? ? :border : "#{s}_with_border".to_sym} unless table[:border].nil?
      style_names.each.map{|s| styles[s]}
    end

    def table_body_cell_data(table, index)
      m = table[:data][:model][index] || table[:data][:model].first.class.new
      table[:data][:columns].map{|attr, s| m.send(attr)}
    end

    def add_padding_bottom(region, padding_bottom)
      padding_bottom = padding_bottom || 1

      padding_bottom.times.each{ add_row Array.new(region.w, nil)}

      @_y += region.h + padding_bottom
    end

    def add_sub_rows(index_row, data, columns, values, options={})
      current_y = options[:current_y]
      h = 0

      data.each do |m|
        data = columns.map do |attr, s|
          value = values.nil? ? nil : values[attr]
          value.nil? ? m.send(attr) : value.call(options[:region], index_row+1, m)
        end

        if options[:has_parent_region]
          current_y = add_row_at_position(data, options[:body_cell_styles], options[:start_x], current_y)
        else
          sheet.add_row data, style: options[:body_cell_styles]
        end

        index_row += 1
        h += 1 # increase height of table
      end

      {index_row: index_row, current_y: current_y, h: h}
    end
  end
end