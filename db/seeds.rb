# Create Items
item_attributes = [
  { name: 'Água', cost: 4 },
  { name: 'Comida', cost: 3 },
  { name: 'Remédio', cost: 2 },
  { name: 'Munição', cost: 1 },
]

item_attributes.each do |attrs|
  Item.create!(name: attrs[:name], cost: attrs[:cost])
end
