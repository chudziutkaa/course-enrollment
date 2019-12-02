require 'rails_helper'

describe AuthenticateResource do
  subject { described_class.call(params) }

  let(:email) { 'resource@example.com' }
  let(:password) { 'very_hard_to_guess_password' }

  describe '.call' do
    context 'when email and password params are present' do
      let(:params) do
        { email: email, password: password }
      end

      context 'when resource exists' do
        let(:resource) { create(:employee, email: email, password: password) }

        context 'when password is correct' do
          let(:token) { 'super_token' }
          let(:secret_key_base) { 'super_secret_key_base' }
          let(:encoding_params) do
            {
              resource_id: resource.id,
              exp: 24.hours.from_now.to_i
            }
          end

          before do
            expect(Employee).to receive(:find_by!).and_return(resource)
            expect(resource).to receive(:authenticate).and_return(resource)
            allow(Rails.application.credentials).to receive(:[])
              .with(:secret_key_base).and_return(secret_key_base)
            expect(JsonWebToken).to receive(:encode)
              .with(encoding_params, secret_key_base).and_return(token)
          end

          it 'generates a token for resource' do
            Timecop.freeze(Time.zone.now) do
              subject
            end
          end
        end

        context 'when password is incorrect' do
          before do
            expect(Employee).to receive(:find_by!).and_return(resource)
            expect(resource).to receive(:authenticate).and_return(false)
          end

          it 'raises InvalidCredentials' do
            expect { subject }.to raise_error(AuthenticateResource::InvalidCredentials,
              'Invalid password')
          end
        end
      end

      context 'when resource does not exist' do
        it 'raises RecordNotFound' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when email or password param is missing' do
      shared_examples 'invalid params' do
        it 'raises MissingParams' do
          expect { subject }.to raise_error(AuthenticateResource::MissingParams,
            'Email or password are missing')
        end
      end

      describe 'email missing' do
        let(:params) { { password: password } }

        it_behaves_like 'invalid params'
      end

      describe 'password missing' do
        let(:params) { { email: email } }

        it_behaves_like 'invalid params'
      end
    end
  end
end
