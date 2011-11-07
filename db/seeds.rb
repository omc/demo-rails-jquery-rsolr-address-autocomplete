# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DOCS       = (ENV['DOCS'] || 1_000_000).to_i
BATCH_SIZE = 1_000
BATCHES    = DOCS / BATCH_SIZE

BATCHES.times do
  docs = (0..BATCH_SIZE).collect do
    address = "#{Faker::Address.street_address(rand < 0.25)}\n#{Faker::Address.city}, #{Faker::Address.us_state_abbr} #{Faker::Address.zip_code}"
    doc = {
      :id => Time.now.to_i.to_s.split(//).sort_by{rand}.join,
      :address_texts => address
    }
  end
  
  $solr.add docs
  $solr.commit
  print "."
  
end
