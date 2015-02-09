module Heartcheck
  module Controllers
    describe Essential do
      subject(:controller) { described_class.new }

      describe '#index' do
        subject(:index) { controller.index }

        let(:check_01) { { dummy1: { status: :ok } } }
        let(:check_02) { { dummy2: { status: :ok } } }

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

        it { is_expected.to eq(Oj.dump([check_01, check_02])) }
      end
    end
  end
end
