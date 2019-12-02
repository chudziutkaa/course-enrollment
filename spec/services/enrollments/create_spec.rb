require 'rails_helper'

describe Enrollments::Create do
  subject { described_class.call(course.id, user.id) }

  let(:course) { create(:course) }
  let(:user) { create(:user) }

  describe 'call' do
    context 'when user successfully enrolled to course' do
      it 'creates enrollment' do
        expect { subject }.to change { Enrollment.count }.by(1)
        expect(Enrollment.last).to have_attributes(
          course_id: course.id, user_id: user.id
        )
      end

      it "increments course's users counter" do
        expect { subject }.to change { course.reload.users_count }.by(1)
      end
    end

    context 'when enrollment fails' do
      before do
        allow_any_instance_of(Enrollment).to receive(:valid?).and_return(false)
      end

      it 'does not create enrollment' do
        expect { subject }.not_to change { Enrollment.count }
      end

      it "does not increment course's users counter" do
        expect { subject }.not_to change { course.reload.users_count }
      end
    end
  end
end
