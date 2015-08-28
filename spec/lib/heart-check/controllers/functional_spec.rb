module Heartcheck
  module Controllers
    describe Functional do
      subject(:controller) { described_class.new }

      describe '#index' do
        subject(:index) { controller.index }

        let(:check_01) { { dummy1: { status: :ok } , time: 1100 } }
        let(:check_02) { { dummy2: { status: :ok } , time: 100 } }

        before do
          expect(Time).to receive(:now).and_return(
                            # millisec time calc :p
                            0.1, 1.2, # (1.2 - 0.1) * 1000.0 = 1100
                            2.9, 3.0  # (3.0 - 2.9) * 1000.0 = 100
                          )

          Heartcheck.setup do |monitor|
            monitor.add :dummy1 do |c|
              c.add_service(name: 'dummy1')
              c.functional = true
            end

            monitor.add :dummy2 do |c|
              c.add_service(name: 'dummy2')
              c.functional = true
            end
          end
        end

        it { is_expected.to eq(Oj.dump([check_01, check_02])) }
      end
    end
  end
end
