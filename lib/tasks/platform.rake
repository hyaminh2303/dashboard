namespace :platform do
  desc "Create 4 platforms with parse options"
  task create: :environment do
    p = Platform.new(name: 'PocketMath', options: '{"ext":"csv","start":1,"group_name":{"col":"A","single_row":"1","skip_rows":1},"end_group":{"col":"A","value":""},"attributes":{"date":{"col":"A","type":"date","options":{"format":"%Y-%m-%d"}},"views":{"col":"C","type":"integer","options":{"delimiter":""}},"clicks":{"col":"D","type":"integer","options":{"delimiter":""}},"spend":{"col":"B","type":"money"}}}')
    p.save! && puts('Added PocketMath') if p.valid?

    p = Platform.new(name: 'BidsTalk', options: '{"ext":"csv","start":2,"end":{"col":"A","value":""},"group_name":{"col":"B"},"attributes":{"date":{"col":"A","type":"date","options":{"format":"%Y-%m-%d"}},"views":{"col":"C","type":"integer","options":{"delimiter":","}},"clicks":{"col":"D","type":"integer","options":{"delimiter":","}},"spend":{"col":"F","type":"money"}}}')
    p.save! && puts('Added BidsTalk') if p.valid?

    p = Platform.new(name: 'Immobi', options: '{"ext":"csv","start":6,"group_name":{"col":"B"},"attributes":{"date":{"col":"A","type":"date","options":{"format":"%Y-%m-%d %H:%M:%S"}},"views":{"col":"C","type":"integer"},"clicks":{"col":"D","type":"integer"},"spend":{"col":"F","type":"money"}}}')
    p.save! && puts('Added Immobi') if p.valid?

    p = Platform.new(name: 'MMedia', options: '{"ext":"csv","start":1,"end":{"col":"A","value":"TOTAL"},"group_name":{"col":"A","single_row":"1"},"attributes":{"date":{"col":"A","type":"date","options":{"format":"%m/%d/%Y"}},"views":{"col":"B","type":"integer","options":{"delimiter":","}},"clicks":{"col":"C","type":"integer","options":{"delimiter":","}},"spend":{"col":"E","type":"money"}}}')
    p.save! && puts('Added MMedia') if p.valid?

    p = Platform.new(name: 'Google AdX', options: '{"ext":"csv","start":3,"end":{"col":"A","value":"Total - all but removed ad groups"},"group_name":{"col":"C"},"attributes":{"date":{"col":"A","type":"date","options":{"format":"%Y-%m-%d"}},"views":{"col":"G","type":"integer","options":{"delimiter":","}},"clicks":{"col":"F","type":"integer","options":{"delimiter":","}},"spend":{"col":"J","type":"money"}}}')
    p.save! && puts('Added Google AdX') if p.valid?
  end

end
