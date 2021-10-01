# frozen_string_literal: true

module Heartcheck
  module Controllers
    describe Info do
      subject(:controller) { described_class.new }

      describe '#index' do
        subject(:index) { controller.index }

        let(:info1) { 'dummy1' }
        let(:info2) { 'dummy2' }

        before do
          Heartcheck.setup do |monitor|
            monitor.add :dummy1 do |c|
              c.add_service(name: 'dummy1')
            end

            monitor.add :dummy2 do |c|
              c.add_service(name: 'dummy2')
            end
          end
        end

        it { is_expected.to eq(MultiJson.dump([info1, info2])) }
      end
    end
  end
end
