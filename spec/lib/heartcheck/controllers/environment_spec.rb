module Heartcheck
  module Controllers
    describe Environment do
      subject(:controller) { described_class.new }
      describe '#index' do
        subject(:index) { MultiJson.load(controller.index, symbolize_keys: true) }

        before do
          stub_const('RUBY_VERSION', '2.4.0')
        end

        let(:system_info_example) { Struct.new(:example_key).new('example_value') }

        context "given Rails is used" do
          before do
            stub_const('Rails::VERSION::STRING', '5.0.0')
          end

          it 'gets info from the right constants and functions' do
            allow(Sys::Uname).to receive(:uname).and_return(system_info_example)
            is_expected.to include(
              :system_info => { :example_key => 'example_value' },
              :ruby_version => '2.4.0',
              :rails_version => '5.0.0'
            )
            expect(Sys::Uname).to have_received(:uname)
          end

          let(:system_info) do
            MultiJson.load(controller.index, symbolize_keys: true)[:system_info]
          end

          let(:ruby_version) do
            MultiJson.load(controller.index, symbolize_keys: true)[:ruby_version]
          end

          let(:rails_version) do
            MultiJson.load(controller.index, symbolize_keys: true)[:rails_version]
          end

          it 'gets the info in the expected format' do
            expect(system_info).to be_a(Hash)
            expect(system_info).to include(
              :sysname,
              :nodename,
              :release,
              :version,
              :machine,
              :domainname
            )
            expect(system_info[:sysname]).to be_a(String)
            expect(system_info[:nodename]).to be_a(String)
            expect(system_info[:release]).to be_a(String)
            expect(system_info[:version]).to be_a(String)
            expect(system_info[:machine]).to be_a(String)
            expect(system_info[:domainname]).to be_a(String)
            expect(ruby_version).to be_a(String)
            expect(rails_version).to be_a(String)
          end
        end

        context "given Rails is not used" do
          it 'gets the info indicating Rails is not used' do
            allow(Sys::Uname).to receive(:uname).and_return(system_info_example)
            is_expected.to include(
              :system_info => { :example_key => 'example_value' },
              :ruby_version => '2.4.0',
              :rails_version => '(none)'
            )
            expect(Sys::Uname).to have_received(:uname)
          end
        end
      end
    end
  end
end
