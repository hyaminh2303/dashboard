module PlatformsHelper
  def option_builder(o)
    Jbuilder.encode do |json|
      json.ext o[:opt_ext]
      json.start o[:opt_start].to_i

      unless o[:opt_title_row] == ''
        json.title_row o[:opt_title_row].to_i
      end


      unless o[:opt_end_col] == ''
        json.end do
          json.col o[:opt_end_col]
          json.value o[:opt_end_value]
        end
      end

      unless o[:opt_date_range_col] == '' && o[:opt_date_range_row] == ''
        json.date_range do
          json.col o[:opt_date_range_col]
          json.row o[:opt_date_range_row]
        end
      end


      json.group_name do
        json.col o[:opt_group_name_col]

        unless o[:opt_group_name_skip_rows] == ''
          json.skip_rows o[:opt_group_name_skip_rows].to_i
        end

        if o[:opt_group_name_single_row] == '1'
          json.single_row o[:opt_group_name_single_row]
        end
      end

      unless o[:opt_end_group_col] == ''
        json.end_group do
          json.col o[:opt_end_group_col]
          json.value o[:opt_end_group_value]
        end
      end

      json.attributes do
        json.date do
          json.col o[:opt_attrs_date_col]
          json.type :date
          json.options do
            json.format o[:opt_attrs_date_format]
          end
        end

        json.views do
          json.col o[:opt_attrs_views_col]
          json.type :integer

          unless o[:opt_attrs_views_delimiter].empty?
            json.options do
              json.delimiter o[:opt_attrs_views_delimiter]
            end
          end
        end

        json.clicks do
          json.col o[:opt_attrs_clicks_col]
          json.type :integer

          unless o[:opt_attrs_clicks_delimiter].empty?
            json.options do
              json.delimiter o[:opt_attrs_clicks_delimiter]
            end
          end
        end

        json.spend do
          json.col o[:opt_attrs_spend_col]
          json.type :money
        end
      end
    end
  end
end
