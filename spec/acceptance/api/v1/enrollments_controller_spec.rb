require 'rails_helper'

resource 'Enrollments' do
  explanation 'Enrollments resource for keeping users enrollments for courses.
               Two endpoints provided: POST and DELETE'
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Host', '127.0.0.1'

  let!(:employee) { create(:employee) }

  before do
    authorize_resource(employee)
  end

  post 'api/v1/enrollments' do
    with_options scope: :enrollment do
      parameter :course_id, type: :integer, required: true
      parameter :user_id, type: :integer, required: true
    end

    let(:course) { create(:course) }
    let(:user) { create(:user) }

    context 'when all permitted parameters' do
      let(:params) do
        {
          enrollment: {
            course_id: course.id,
            user_id: user.id
          }
        }
      end

      context 'when enrollment successfully created' do
        example 'User successfully enrolled to course' do
          do_request

          expect(status).to eq(201)
          expect(response_body).to eq(
            { message: 'User successfully enrolled to the course' }.to_json
          )
        end
      end

      context 'when enrollment failed to create' do
        before do
          allow_any_instance_of(Enrollment).to receive(:valid?).and_return(false)
        end

        example 'Enrollment to course failed' do
          do_request

          expect(status).to eq(422)
          expect(response_body).to eq(
            { error: 'Enrollment user to this course failed' }.to_json
          )
        end
      end
    end

    context 'when missing parameters' do
      let(:params) do
        {
          enrollment: {}
        }
      end

      example 'Enrollment creation with missing parameter' do
        do_request

        expect(status).to eq(422)
        expect(response_body).to eq({ error: 'Missing required parameters' }.to_json)
      end
    end
  end

  delete 'api/v1/enrollments/:id' do
    parameter :id, type: :integer, required: true

    context 'when user found' do
      let!(:enrollment) { create(:enrollment) }
      let(:id) { enrollment.id }

      example 'User successfully withdrawed from course' do
        do_request

        expect(status).to eq(204)
      end
    end

    context 'when enrollment not found' do
      let(:id) { 1 }

      example 'User has not been enrolled to the course' do
        do_request

        expect(status).to eq(422)
        expect(response_body).to eq({ error: 'Cannot withdraw user from this course' }.to_json)
      end
    end
  end
end
