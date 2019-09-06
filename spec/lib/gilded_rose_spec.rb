require 'spec_helper'
require 'gilded_rose'

# RSpec.describe GildedRose do
#   it 'tests something'
# end

RSpec.describe Item do
  let(:item) { build :item }

  it 'is an Item' do
    expect(item).to be_an described_class
  end

  describe 'Item#to_s' do
    it 'contains the 3 attributes' do
      expect(item.to_s).to eq 'An item, 20, 10'
    end
  end

  describe 'Item#update' do
    it 'does not raise any error' do
      expect { item.update }.not_to raise_error
    end

    context 'when name is Aged Brie' do
      let(:item) do
        build :item, name: 'Aged Brie'
      end

      it 'can receive update without exceptions' do
        expect { item.update }.not_to raise_error
      end
    end

    context 'when quality isn\'t positive' do
      let(:item) do
        build :item, quality: -10
      end

      it 'can receive update without exceptions' do
        expect { item.update }.not_to raise_error
      end
    end

    context 'when name is Sulfuras, Hand of Ragnaros' do
      let(:item) do
        build :item, name: 'Sulfuras, Hand of Ragnaros'
      end

      it 'can receive update without exceptions' do
        expect { item.update }.not_to raise_error
      end

      it 'doesn\'t change quality' do
        expect { item.update }.not_to change(item, :quality)
      end

      it 'doesn\' change sell_in' do
        expect { item.update }.not_to change(item, :sell_in)
      end
    end

    context 'when name is Aged Brie' do
      let(:item) do
        build :item, name: 'Aged Brie'
      end

      it 'increases the quality by 1' do
        expect { item.update }.to change(item, :quality).by(1)
      end

      context 'and quality is >= 50' do
        let(:item) do
          super().tap { |i| i.quality = 65 }
        end

        it 'doesn\'t change the quality' do
          expect { item.update }.not_to change(item, :quality)
        end
      end
    end

    context 'when name is Backstage passes to a TAFKAL80ETC concert' do
      let(:item) do
        build :item, name: 'Backstage passes to a TAFKAL80ETC concert'
      end

      context 'and quality is < 50 and sell_in is < 11' do
        let(:item) do
          super().tap { |i| i.quality = 30; i.sell_in = 5 }
        end

        it 'increases the quality by 1' do
          expect { item.update }.to change(item, :quality).by(3)
        end
      end

      context 'and quality is 30 and sell_in is >= 11' do
        let(:item) do
          super().tap { |i| i.quality = 30; i.sell_in = 12 }
        end

        it 'increases the quality by 1' do
          expect { item.update }.to change(item, :quality).by(1)
        end
      end

      context 'and quality is >= 50 or sell_in is < 11' do
        let(:item) do
          super().tap { |i| i.quality = 65; i.sell_in = 5 }
        end

        it 'doesn\'t change the quality' do
          expect { item.update }.not_to change(item, :quality)
        end
      end

      context 'and quality is 49 and sell_in is 55555' do
        let(:item) do
          super().tap { |i| i.quality = 49; i.sell_in = 5 }
        end

        it 'increases the quality by 1' do
          expect { item.update }.to change(item, :quality).by(1)
        end
      end
    end

    context 'if sell_in < 0' do
      let(:item) do
        super().tap { |i| i.sell_in = -5 }
      end

      it 'decreases the quality by -2' do
        expect { item.update }.to change(item, :quality).by(-2)
      end

      context 'and name is Aged Brie' do
        let(:item) do
          Item.for object_like: super(), name: 'Aged Brie'
        end

        it 'decreases the quality by 2' do
          expect { item.update }.to change(item, :quality).by(2)
        end

        context 'and quality is > 50' do
          let(:item) do
            super().tap { |i| i.quality = 65 }
          end

          it 'doesn\'t change quality' do
            expect { item.update }.not_to change(item, :quality)
          end
        end
      end

      context 'and name is Backstage passes to a TAFKAL80ETC concert' do
        let(:item) do
          Item.for(object_like: super(),
                   name: 'Backstage passes to a TAFKAL80ETC concert')
        end

        it 'resets quality' do
          expect { item.update }.to change(item, :quality).to(0)
        end
      end

      context 'and quality is < 0' do
        let(:item) do
          super().tap { |i| i.quality = -5 }
        end

        it 'doesn\'t change quality' do
          expect { item.update }.not_to change(item, :quality)
        end
      end

      context 'and name is Sulfuras, Hand of Ragnaros' do
        let(:item) do
          Item.for object_like: super(), name: 'Sulfuras, Hand of Ragnaros'
        end

        it 'doesn\'t change quality' do
          expect { item.update }.not_to change(item, :quality)
        end
      end
    end
  end
end
