class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item.update
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def self.for(name: , sell_in: , quality: )
    if name == 'Aged Brie' then
      AgedBrie.new(name, sell_in, quality)
    elsif name == 'Backstage passes to a TAFKAL80ETC concert'
      Backstage.new(name, sell_in, quality)
    elsif name == 'Sulfuras, Hand of Ragnaros'
      Sulfuras.new(name, sell_in, quality)
    else
      new(name, sell_in, quaility)
    end
  end

  class AgedBrie < Item
    def update
      @quality += 1 if @quality < 50
      @sell_in -= 1
      @quality += 1 if @quality < 50 && @sell_in < 0
    end
  end

  class Backstage < Item
    def update
      @quality += 1 if @quality < 50
      @quality += 1 if @quality < 50 && @sell_in < 11
      @quality += 1 if @quality < 50 && @sell_in < 6
      @sell_in = @sell_in - 1
      @quality = 0 if @sell_in < 0
    end
  end

  class Sulfuras < Item
    def update
    end
  end

  def update
    @quality -= 1 if @quality > 0
    @sell_in -= 1
    @quality -= 1 if @quality > 0 && @sell_in < 0
  end
end
