require 'forwardable'

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

class Quality
  extend Forwardable
  include Comparable

  def initialize(quality)
    @quality = quality
  end

  def_delegator :@quality, :to_i
  def_delegator :@quality, :to_s
  def_delegator :@quality, :<=>

  def increase
    @quality += 1 if @quality < 50
  end

  def decrease
    @quality -= 1 if @quality > 0
  end

  def reset
    @quality = 0
  end
end

class Item
  attr_accessor :name, :sell_in

  def quality
    @quality.to_i
  end

  def quality=(i)
    @quality = Quality.new(i)
  end

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = Quality.new(quality)
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
      @quality.increase
      @sell_in -= 1
      @quality.increase if sell_in < 0
    end
  end

  class Backstage < Item
    def update
      @quality.increase
      @quality.increase if @sell_in < 11
      @quality.increase if @sell_in < 6
      @sell_in = @sell_in - 1
      @quality.reset if @sell_in < 0
    end
  end

  class Sulfuras < Item
    def update
    end
  end

  def update
    @quality.decrease
    @sell_in -= 1
    @quality.decrease if @sell_in < 0
  end
end
