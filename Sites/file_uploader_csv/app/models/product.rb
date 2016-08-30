require 'csv'
class Product < ActiveRecord::Base
  attr_accessible :name, :price, :released_on

  validates_presence_of :price

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.tempfile) do |row|
      puts row.inspect
      record = Product.new(
        :name => row[0],
        :released_on => row[1],
        :price => row[2]
      )
      record.save!
    end
  end
end
