require 'rails_helper'

describe AuthorizeUser do
  describe '.call' do
    context 'when authorization header present' do
      subject { described_class.call(headers) }

      let(:user_id) { 1 }
      let!(:user) { create(:user, :worker, id: user_id) }
      let(:token) { 'super_token' }
      let(:secret_key_base) { 'super_secret_key_base' }
      let(:headers) do
        {
          'Authorization' => "Bearer #{token}"
        }
      end

      let(:expected_body) do
        {
          'user_id' => user_id,
          'exp' => 1_575_286_672
        }.with_indifferent_access
      end

      before do
        allow(Rails.application.credentials).to receive(:[])
          .with(:secret_key_base).and_return(secret_key_base)
        expect(JsonWebToken).to receive(:decode)
          .with(token, secret_key_base).and_return(expected_body)
      end

      it 'returns user' do
        expect(subject).to eq(user)
      end
    end

    context 'when authorization header missing' do
      subject { described_class.call }

      it 'raises AuthorizationRequestHeaderMissing' do
        expect { subject }.to raise_error(AuthorizeUser::AuthorizationRequestHeaderMissing,
          'Missing Authorization Request header')
      end
    end
  end
end
