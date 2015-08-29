require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#class_for_item_menu" do
    before do
      helper.params.merge!(controller: 'admin/base')
    end

    it 'does be active if current controller is base' do
      expect(helper.class_for_item_menu('base')).to eq('active')
    end

    it 'does be nil if current controller is not base' do
      expect(helper.class_for_item_menu('another')).to be_nil
    end
  end

  describe '#class_for_subitem_menu' do
    before do
      helper.params.merge!(action: 'show')
    end

    it 'does be active if current action is show' do
      expect(helper.class_for_subitem_menu('show')).to eq('active')
    end

    it 'does be nil if current action is a different action than show' do
      expect(helper.class_for_subitem_menu('index')).to be_nil
    end
  end

  describe '#flash_messages' do
    it "does render partial 'flash_messages'" do
      expect(helper.flash_messages).to render_template('application/_flash_messages')
    end
  end

  describe '#custom_flash_messages' do
    it "does render partial 'custom_flash_messages'" do
      expect(helper.custom_flash_messages).to render_template('application/_custom_flash_messages')
    end
  end
end
