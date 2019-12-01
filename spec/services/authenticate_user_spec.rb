require 'rails_helper'

describe AuthenticateUser do
  subject { described_class.call(params) }

  let(:email) { 'user@example.com' }
  let(:password) { 'very_hard_to_guess_password' }

  describe '.call' do
    context 'when email and password params are present' do
      let(:params) do
        { email: email, password: password }
      end

      context 'when user exists' do
        let(:user) { create(:user, :worker, email: email, password: password) }

        context 'when password is correct' do
          let(:token) { 'super_token' }
          let(:secret_key_base) { 'super_secret_key_base' }
          let(:encoding_params) do
            {
              user_id: user.id,
              exp: 24.hours.from_now.to_i
            }
          end

          before do
            expect(User).to receive_message_chain(:worker, :find_by!).and_return(user)
            expect(user).to receive(:authenticate).and_return(user)
            allow(Rails.application.credentials).to receive(:[])
              .with(:secret_key_base).and_return(secret_key_base)
            expect(JsonWebToken).to receive(:encode)
              .with(encoding_params, secret_key_base).and_return(token)
          end

          it 'generates a token for user' do
            Timecop.freeze(Time.zone.now) do
              subject
            end
          end
        end

        context 'when password is incorrect' do
          before do
            expect(User).to receive_message_chain(:worker, :find_by!).and_return(user)
            expect(user).to receive(:authenticate).and_return(false)
          end

          it 'raises InvalidCredentials' do
            expect { subject }.to raise_error(AuthenticateUser::InvalidCredentials,
              'Invalid password')
          end
        end
      end

      context 'when user does not exist' do
        it 'raises RecordNotFound' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when email or password param is missing' do
      shared_examples 'invalid params' do
        it 'raises MissingParams' do
          expect { subject }.to raise_error(AuthenticateUser::MissingParams,
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
