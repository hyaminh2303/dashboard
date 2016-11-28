class VastParser
  class << self
    def parse(doc)
      @xml_doc = Nokogiri::XML(doc)
      if valid_doc?
        begin
          parse_vast
        rescue Exception => e
          unsupported_vast
        end
      else
        invalid_vast
      end
    end

    private

    def valid_doc?
      @xml_doc.xpath('//VAST/Ad/InLine').present?
    end

    def invalid_vast
      vast = Vast.new
      vast.errors.add(:base, 'Vast file format is invalid')
      vast
    end

    def unsupported_vast
      vast = Vast.new
      vast.errors.add(:base, 'Vast file format is unsupported')
      vast
    end

    def find_nodes key
      @xml_doc.xpath key
    end

    def parse_attributes node
      items = {}
      node.attributes.map do |k, a|
        items[k] = a.value
      end
      items
    end

    def parse_texts(keys, parent = nil)
      items = {}
      keys.each do |k|
        if parent.blank?
          items[k] = find_nodes("//#{k.to_s.camelize}").text.strip
        else
          items[k] = parent.xpath("*/#{k.to_s.camelize}|#{k.to_s.camelize}").text.strip
        end
      end
      items
    end

    def parse_urls(key, parent = nil)
      items = []
      if parent.blank?
        nodes = find_nodes("//#{key.to_s.camelize}")
      else
        nodes = parent.xpath("*/#{key.to_s.camelize}|#{key.to_s.camelize}")
      end
      nodes.each do |n|
        items << { url: n.text.strip }
      end
      array_to_hash(items)
    end

    def parse_url_node node
      data = parse_attributes node
      data[:url] = node.text.strip
      data
    end

    def array_to_hash arr
      hash = {}
      arr.each_with_index do |a, i|
        hash[i] = a
      end
      hash
    end

    def parse_vast
      params = parse_texts [:ad_system, :ad_title, :description]
      params[:error_urls_attributes] = parse_urls :error
      params[:impressions_attributes] = parse_urls :impression
      params[:linear_ads_attributes] = parse_linear_ads
      params[:companion_ads_attributes] = parse_companion_ads
      params[:non_linear_ads_attributes] = parse_non_linear_ads
      Vast.new(params)
    end

    def parse_linear_ads
      linear_ads = []
      find_nodes('//Linear').each do |node|
        linear_ad = parse_attributes node
        linear_ad.merge!(parse_texts [:duration, :click_through], node)
        linear_ad[:click_trackings_attributes] = parse_urls :click_tracking, node
        linear_ad[:media_files_attributes] = parse_media_files node
        linear_ad[:tracking_events_attributes] = parse_tracking_events node
        linear_ads << linear_ad
      end
      array_to_hash(linear_ads)
    end

    def parse_companion_ads
      companion_ads = []
      find_nodes('//Companion').each do |node|
        companion_ad = parse_attributes node
        companion_ad[:click_through] = node.xpath('CompanionClickThrough').text.strip
        companion_ad[:click_trackings_attributes] = parse_urls :companion_click_tracking, node
        companion_ad[:tracking_events_attributes] = parse_tracking_events node
        companion_ad[:ad_resources_attributes] = parse_ad_resources node
        companion_ads << companion_ad
      end
      array_to_hash(companion_ads)
    end

    def parse_non_linear_ads
      non_linear_ads = []
      find_nodes('//NonLinearAds').each do |node|
        non_linear_ad = {
            tracking_events_attributes: parse_tracking_events(node),
            non_linear_resources_attributes: parse_non_linear_resources(node)
        }
        non_linear_ads << non_linear_ad
      end
      array_to_hash(non_linear_ads)
    end

    def parse_media_files parent
      media_files = []
      parent.xpath('*/MediaFile').each do |node|
        media_file = parse_url_node node
        media_files << media_file
      end
      array_to_hash(media_files)
    end

    def parse_tracking_events parent
      tracking_events = []
      parent.xpath('*/Tracking').each do |node|
        tracking_event = parse_url_node node
        tracking_events << tracking_event
      end
      array_to_hash(tracking_events)
    end

    def parse_ad_resources parent
      ad_resources = []
      parent.xpath('StaticResource|HTMLResource|IFrameResource').each do |node|
        ad_resource = parse_url_node node
        if node.name == 'HTMLResource'
          ad_resource['creativeType'] = 'html'
        elsif node.name == 'IFrameResource'
          ad_resource['creativeType'] = 'iframe'
        end
        ad_resources << ad_resource
      end
      array_to_hash(ad_resources)
    end

    def parse_non_linear_resources parent
      non_linear_resources = []
      parent.xpath('NonLinear').each do |node|
        non_linear_resource = parse_attributes node
        non_linear_resource[:click_through] = node.xpath('NonLinearClickThrough').text.strip
        non_linear_resource[:click_trackings_attributes] = parse_urls :non_linear_click_tracking, node
        non_linear_resource[:ad_resources_attributes] = parse_ad_resources node
        non_linear_resources << non_linear_resource
      end
      array_to_hash(non_linear_resources)
    end
  end
end