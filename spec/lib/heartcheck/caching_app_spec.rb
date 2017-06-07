require 'rack/test'
require 'heartcheck/caching_app'

module Heartcheck
  describe CachingApp do
    include Rack::Test::Methods

    let(:app) { described_class.new(super_app, ttl, cache) }
    let(:ttl) { 5 }
    let(:cache) { double(Heartcheck::CachingApp::Cache) }
    let(:super_app) { double(Heartcheck::App) }
    let(:controller) { Heartcheck::Controllers::Essential }
    let(:response) { [200, { 'Content-type' => 'application/json' }, ["[]"]] }

    before do
      allow(super_app).to receive(:call).with(anything).and_return(response)
      allow(cache).to receive(:result).with(instance_of(Class))
    end

    it 'forwards to the original app when value is not cached' do
      expect(cache).to receive(:result).with(controller).and_return(nil)

      get '/'

      expect(last_response.body).to eq("[]")
      expect(super_app).to have_received(:call)
    end

    context 'when value is cached' do
      let(:result) { '{"some":"result"}' }

      before do
        expect(cache).to receive(:result).with(controller).and_return(result)
      end

      it 'returns the cached result and does not call the original app' do
        get '/'

        expect(last_response.body).to eq(result)
      end

      it 'returns status 200 OK' do
        get '/'

        expect(last_response.status).to eq(200)
      end

      it 'returns JSON content' do
        get '/'

        expect(last_response.headers)
          .to include('Content-type' => 'application/json')
      end

      it 'does not call the original app' do
        get '/'

        expect(super_app).not_to have_received(:call)
      end
    end

    context 'on an unknown route' do
      it 'forwards to the original app' do
        get '/not-found'

        expect(last_response.body).to eq("[]")
        expect(super_app).to have_received(:call)
      end

      it 'does not hit the cache' do
        get '/not-found'

        expect(cache).not_to have_received(:result)
      end
    end
  end
end
