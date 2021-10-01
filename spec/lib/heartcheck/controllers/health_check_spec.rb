# frozen_string_literal: true

module Heartcheck
  module Controllers
    describe HealthCheck do
      subject(:controller) { described_class.new }

      describe '#index' do
        subject(:index) { controller.index }

        it { is_expected.to eq(MultiJson.dump({ status: 'ok' })) }
      end
    end
  end
end
