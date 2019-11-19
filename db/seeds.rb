require 'csv'

puts 'Cleaning Products'
Product.destroy_all

puts 'Creating products......'
filepath = 'db/seed_csv.csv'

CSV.foreach(filepath) do |row|
  # puts "#{row[0]} | #{row[1]} | #{row[2]} | #{row[3]}"
  product = Product.new(
    barcode: "#{row[0]}".to_i,
    name: "#{row[1]}",
    ingredients: "#{row[2]}")
    product.remote_front_photo_url ="#{row[3]}"
    product.save!
end

# --------- For barcode scan testing ---------
candy = Product.new(barcode: 4902888232374, name: "ramune", ingredients: "glucose, tapioca starch, milk calcium, acidulant, emulsilfier, aroma essence, containing milk constituent and gelatin")
candy.remote_front_photo_url = "https://res.cloudinary.com/nst-img/image/upload/v1574132180/product_test_1_heaobs.jpg"
candy.save!
# -------------------------------------------

puts "...created #{Product.count} products"
