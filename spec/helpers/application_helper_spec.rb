require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#is_active_controller" do
    before do
      helper.params.merge!(controller: 'admin/base')
    end

    it 'does be active if current controller is base' do
      expect(helper.is_active_controller('base')).to eq('active')
    end

    it 'does be nil if current controller is not base' do
      expect(helper.is_active_controller('another')).to be_nil
    end
  end

  describe '#is_active_action' do
    before do
      helper.params.merge!(action: 'show')
    end

    it 'does be active if current action is show' do
      expect(helper.is_active_action('show')).to eq('active')
    end

    it 'does be nil if current action is a different action than show' do
      expect(helper.is_active_action('index')).to be_nil
    end
  end

  describe '#flash_messages' do
    it "does render partial 'flash_messages'" do
      expect(helper.flash_messages).to render_template('application/_flash_messages')
    end
  end
end