require 'forwardable'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each(&:update)
  end
end

# Item quality
#
# A type safety wrapper on integers, so arbitrary arithmetics don't work.
# Quality changes values according to strict rules.
class Quality
  extend Forwardable
  include Comparable

  # New quality
  # @param quality [Integer] The non-wrapped quality value
  def initialize(quality)
    @quality = quality
  end

  def_delegator :@quality, :to_i
  def_delegator :@quality, :to_s
  def_delegator :@quality, :<=>

  # Increases the quality by one
  def increase
    @quality += 1 if @quality < 50
  end

  # Decreases the quality by one
  def decrease
    @quality -= 1 if @quality.positive?
  end

  # Resets quality to 0
  def reset
    @quality = 0
  end
end

# Item has a name, a quality and a sell_in
class Item
  attr_accessor :sell_in
  attr_reader :name


  # @return [Integer] quality value
  def quality
    @quality.to_i
  end

  # Sets the quality value to i
  # @param quality [Integer] quality
  def quality=(quality)
    @quality = Quality.new(quality)
  end

  # new item
  # @param name [String] Item name
  # @param sell_in [Integer] sell in quantities
  # @param quality [Integer] item quality
  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = Quality.new(quality)
  end

  # @see Object.to_s
  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  # Item factory. Produces an item with the appropriate type
  # @param name [String] Item name
  # @param sell_in [Integer] sell in quantities
  # @param quality [Integer] item quality
  def self.for(name:, sell_in:, quality:)
    case name
    when 'Aged Brie' then AgedBrie.send(:new, name, sell_in, quality)
    when 'Backstage passes to a TAFKAL80ETC concert'
      Backstage.send(:new, name, sell_in, quality)
    when 'Sulfuras, Hand of Ragnaros'
      Sulfuras.send(:new, name, sell_in, quality)
    else new(name, sell_in, quality)
    end
  end

  # Disable .new, use the factory!
  private_class_method :new

  # Item with name being Aged Brie
  class AgedBrie < Item
    # @see {Item.update}
    def update
      @quality.increase
      @sell_in -= 1
      @quality.increase if sell_in.negative?
    end
  end

  # Item with name being Backstage passes to a TAFKAL80ETC concert
  class Backstage < Item
    # @see {Item.update}
    def update
      @quality.increase
      @quality.increase if @sell_in < 11
      @quality.increase if @sell_in < 6
      @sell_in = @sell_in - 1
      @quality.reset if @sell_in < 0
    end
  end

  # Item with name being Sulfuras, Hand of Ragnaros
  class Sulfuras < Item
    # @see {Item.update}
    def update; end
  end

  # Updates item quality and sell_in according to Gilded Rose rules
  def update
    @quality.decrease
    @sell_in -= 1
    @quality.decrease if @sell_in.negative?
  end
end
