require 'rails_helper'

resource 'Users' do
  explanation 'Users resource. Two endpoints provided: POST and DELETE'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  let!(:employee) { create(:employee) }

  before do
    authorize_resource(employee)
  end

  post 'api/v1/users' do
    parameter :email, type: :string, required: true

    let(:email) { 'user@example.com' }

    context 'when all permitted parameters' do
      let(:params) do
        {
          user: {
            email: email
          }
        }
      end

      context 'when valid parameters' do
        example 'User successfully created' do
          do_request

          expect(status).to eq(201)
          expect(response_body).to eq({ message: 'User successfully created' }.to_json)
        end
      end

      context 'when invalid parameters' do
        let!(:user) { create(:user, email: email) }

        example 'User email not unique' do
          do_request

          expect(status).to eq(422)
          expect(response_body).to eq({ error: 'Email has already been taken' }.to_json)
        end
      end
    end

    context 'when missing parameters' do
      let(:params) do
        {
          user: {}
        }
      end

      example 'User creation with missing parameter' do
        do_request

        expect(status).to eq(422)
        expect(response_body).to eq({ error: 'Missing required parameters' }.to_json)
      end
    end
  end

  delete 'api/v1/users/:id' do
    parameter :id, type: :integer, required: true

    context 'when user found' do
      let!(:user) { create(:user) }
      let(:id) { user.id }

      example 'User successfully deleted' do
        do_request

        expect(status).to eq(204)
      end
    end

    context 'when user not found' do
      let(:id) { 1 }

      example 'User not found' do
        do_request

        expect(status).to eq(404)
        expect(response_body).to eq({ error: 'Resource not found' }.to_json)
      end
    end
  end
end
