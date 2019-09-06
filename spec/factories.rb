FactoryBot.define do
  factory :item do
    initialize_with { Item.for(name: name, quality: quality, sell_in: sell_in) }

    name { 'An item' }
    quality { 10 }
    sell_in { 20 }
  end
end
