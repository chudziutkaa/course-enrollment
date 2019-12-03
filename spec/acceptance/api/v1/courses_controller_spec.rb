require 'rails_helper'

resource 'Courses' do
  explanation 'Courses resource. Three endpoints provided: GET, POST and DELETE'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  let!(:employee) { create(:employee) }
  let!(:course) { create(:course, users_count: 7) }

  before do
    authorize_resource(employee)
  end

  get 'api/v1/courses' do
    let(:expected_response) do
      {
        'courses' => [
          { 'id' => course.id, 'name' => course.name, 'users_count' => course.users_count }
        ],
        'meta' => {
          'current_page' => 1,
          'next_page' => nil,
          'per_page' => 10,
          'prev_page' => nil,
          'total_count' => 1,
          'total_pages' => 1
        }
      }
    end

    example 'List of courses' do
      do_request

      expect(status).to eq(200)
      expect(JSON.parse(response_body)).to eq(expected_response)
    end
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

      context 'when valid attributes' do
        example 'Course successfully created' do
          do_request

          expect(status).to eq(201)
          expect(response_body).to eq({ message: 'Course successfully created' }.to_json)
        end
      end

      context 'when invalid attributes' do
        before do
          allow_any_instance_of(Course).to receive(:valid?).and_return(false)
          allow_any_instance_of(Course).to receive_message_chain(:errors, :full_messages)
            .and_return(['Invalid parameters'])
        end

        example 'Course not created' do
          do_request

          expect(status).to eq(422)
          expect(response_body).to eq({ error: 'Invalid parameters' }.to_json)
        end
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
