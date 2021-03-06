namespace :dashboard do
  task add_app_category: :environment do
    AppCategory.destroy_all
    [["Automotive", "IAB2"],
    ["Business", "IAB3"],
    ["Careers", "IAB4"],
    ["Education", "IAB5"],
    ["Family & Parenting", "IAB6"],
    ["Health & Fitness", "IAB7"],
    ["Food & Drink", "IAB8"],
    ["Hobbies & Interests", "IAB9"],
    ["Home & Garden", "IAB10"],
    ["Law, Gov't & Politics", "IAB11"],
    ["News", "IAB12"],
    ["Personal Finance", "IAB13"],
    ["Society", "IAB14"],
    ["Science", "IAB15"],
    ["Pets", "IAB16"],
    ["Sports", "IAB17"],
    ["Style & Fashion", "IAB18"],
    ["Technology & Computing", "IAB19"],
    ["Travel", "IAB20"],
    ["Real Estate", "IAB21"],
    ["Shopping", "IAB22"],
    ["Religion & Spirituality", "IAB23"],
    ["Uncategorized", "IAB24"],
    ["Non-Standard Content", "IAB25"],
    ["Illegal Content", "IAB26"]].each do |arr|
      AppCategory.create(name: arr[0], code: arr[1])
    end
  end
end