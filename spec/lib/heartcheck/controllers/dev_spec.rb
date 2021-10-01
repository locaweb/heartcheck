# frozen_string_literal: true

module Heartcheck
  module Controllers
    describe Dev do
      subject(:controller) { described_class.new }

      describe '#index' do
        subject(:index) { controller.index }

        let(:total_time) { { total_execution_time: '0.00 ms' } }

        let(:check1) do
          { dummy1: { status: :ok }, execution_time: '0.00 ms' }
        end

        let(:check2) do
          { dummy2: { status: :ok }, execution_time: '0.00 ms' }
        end

        let(:result) { [check1, check2, total_time] }

        before do
          allow(Time).to receive(:now).and_return(Time.now)

          Heartcheck.setup do |monitor|
            monitor.add :dummy1 do |c|
              c.add_service(name: 'dummy1')
            end
            monitor.add :dummy2 do |c|
              c.add_service(name: 'dummy2')
            end
          end
        end

        it { is_expected.to eq(MultiJson.dump(result)) }
      end
    end
  end
end
