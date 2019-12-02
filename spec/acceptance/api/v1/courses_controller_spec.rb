require 'rails_helper'

resource 'Courses' do
  explanation 'Courses resource. Two endpoints provided: POST and DELETE'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  let!(:employee) { create(:employee) }

  before do
    authorize_resource(employee)
  end

  post 'api/v1/courses' do
    parameter :name, type: :string, required: true

    let(:name) { 'Aerial Hoop' }

    context 'when all permitted parameters' do
      let(:params) do
        {
          course: {
            name: name
          }
        }
      end

      example 'Course successfully created' do
        do_request

        expect(status).to eq(201)
        expect(response_body).to eq({ message: 'Course successfully created' }.to_json)
      end
    end

    context 'when missing parameters' do
      let(:params) do
        {
          course: {}
        }
      end

      example 'Course creation with missing parameter' do
        do_request

        expect(status).to eq(422)
        expect(response_body).to eq({ error: 'Missing required parameters' }.to_json)
      end
    end
  end

  delete 'api/v1/courses/:id' do
    parameter :id, type: :integer, required: true

    context 'when course found' do
      let!(:course) { create(:course) }
      let(:id) { course.id }

      example 'Course successfully deleted' do
        do_request

        expect(status).to eq(204)
      end
    end

    context 'when course not found' do
      let(:id) { 1 }

      example 'Course not found' do
        do_request

        expect(status).to eq(404)
        expect(response_body).to eq({ error: 'Resource not found' }.to_json)
      end
    end
  end
end
