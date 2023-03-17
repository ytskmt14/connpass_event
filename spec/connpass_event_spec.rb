# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe ConnpassEvent do
  it 'has a version number' do
    expect(ConnpassEvent::VERSION).not_to be nil
  end

  describe '::Client' do
    describe '#initialize' do
      it 'has instance variable @connection' do
        client = ConnpassEvent::Client.new
        expect(client.instance_variable_defined?(:@connection)).to eq(true)
        expect(client.instance_variable_get(:@connection).class).to eq(Faraday::Connection)
      end
    end

    describe '#events' do
      before do
        connection_mock = double('connection_mock')
        response_mock = double('response_mock', status: 200, body: File.read('spec/fixtures/response_mock/events.json'))
        allow(Faraday).to receive(:new).and_return(connection_mock)
        allow(connection_mock).to receive(:get).and_return(response_mock)
      end

      it 'returns events' do
        events = ConnpassEvent::Client.new.events
        expect(events.count).to eq(1)
      end
    end
  end

  describe '::Request' do
    describe 'self.params' do
      context 'when no params' do
        it 'should be empty hash' do
          expect(ConnpassEvent::Request.params).to eq({})
        end
      end

      context 'when one defined param' do
        it 'should be hash' do
          expect(ConnpassEvent::Request.params(keyword: 'ruby')).to eq({ keyword: 'ruby' })
        end
      end

      context 'when one undefined param' do
        it 'should be empty hash' do
          expect(ConnpassEvent::Request.params(undefined: 'ruby')).to eq({})
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
