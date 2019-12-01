require 'rails_helper'

resource 'Authentication', type: :acceptance do
  explanation 'User authentication'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  post 'api/v1/authenticate' do
    parameter :email, type: :string, required: true
    parameter :password, type: :string, required: true

    let(:email) { 'worker@danceschool.org' }
    let(:password) { 'pass123456' }
    let!(:user) { create(:user, :worker, email: email, password: password) }
    let(:token) { 'super_token' }

    context 'when all parameters are given' do
      context 'when correct credentials' do
        let(:params) { { email: email, password: password } }

        before do
          expect(JsonWebToken).to receive(:encode).and_return(token)
        end

        example 'Authentication with email and password' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq({ auth_token: token }.to_json)
        end
      end

      context 'when wrong credentials' do
        let(:params) { { email: email, password: 'invalid_password' } }

        example 'Authentication with wrong email and password' do
          do_request

          expect(status).to eq(401)
          expect(response_body).to eq({ error: 'Invalid password' }.to_json)
        end
      end
    end

    context 'when parameter is missing' do
      context 'when email or password param is missing' do
        shared_examples 'invalid params' do
          example 'Authentication with missing parameter' do
            do_request

            expect(status).to eq(422)
            expect(response_body).to eq({ error: 'Missing required parameters' }.to_json)
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
end
