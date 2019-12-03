require 'rails_helper'

resource 'User Courses' do
  explanation 'Courses resource. Two endpoints provided: POST and DELETE'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  let(:employee) { create(:employee) }
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let!(:enrollment) { create(:enrollment, user: user, course: course) }

  before do
    authorize_resource(employee)
  end

  get 'api/v1/users/:user_id/courses' do
    parameter :user_id, type: :integer, required: true

    let(:user_id) { user.id }
    let(:expected_response) do
      {
        'courses' => [
          { 'id' => course.id, 'name' => course.name }
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

    example 'List of courses user has enrolled to' do
      do_request

      expect(status).to eq(200)
      expect(JSON.parse(response_body)).to eq(expected_response)
    end
  end
end
