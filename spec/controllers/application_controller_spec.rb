require 'rails_helper'

RSpec.describe Admin::BaseController, type: :controller do
  describe '#scope_for_ng_table' do
    before do
      controller.params.merge!({
        page: 1,
        count: 1,
        sorting: { 'name' => 'asc' },
        filter: { 'general' => 'john' }
      })
    end

    context 'when recording on session' do
      before do
        controller.scope_for_ng_table(Administrator)
      end

      it 'does store page params on session' do
        expect(controller.get_controller_config(:count)).to eq(1)
      end

      it 'does store count params on session' do
        expect(controller.get_controller_config(:page)).to eq(1)
      end

      it 'does store sorting params on session' do
        expect(controller.get_controller_config(:sorting)).to eq('name' => 'asc')
      end

      it 'does store filter params on session' do
        expect(controller.get_controller_config(:filter)).to eq('general' => 'john')
      end
    end

    context 'when retrieving data based on params' do
      subject(:scope) { controller.scope_for_ng_table(Administrator) }
      before do
        create :administrator, name: 'Albert'
        create :administrator, name: 'John'
      end

      it "does return ordered ascending by name" do
        expect(scope.first.name).to eq('Albert')
      end

      it "does return ordered just one administrator" do
        expect(scope.size).to eq(1)
      end
    end
  end

  describe '#filters' do
    context "when nothing is stored on session" do
      it "does return default values" do
        expect(controller.send(:filters)).to eq({ page: 1, count: 25, sorting: {}, filter: {general: ''} })
      end
    end

    context "when have parameters stored on session" do
      let(:params) do
        {
          page: 1,
          count: 1,
          sorting: { 'name' => 'asc' },
          filter: { 'general' => 'john' }
        }
      end

      before do
        controller.params.merge!(params)
        controller.scope_for_ng_table(Administrator)
      end

      it "does return the same parameters" do
        expect(controller.send(:filters)).to eq(params)
      end
    end
  end
end