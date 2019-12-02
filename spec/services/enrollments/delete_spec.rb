require 'rails_helper'

describe Enrollments::Delete do
  subject { described_class.call(enrollment_id) }

  describe 'call' do
    context 'when user successfully withdrawed from course' do
      let(:course) { create(:course, users_count: 1) }
      let(:user) { create(:user) }
      let!(:enrollment) { create(:enrollment, course: course, user: user) }
      let(:enrollment_id) { enrollment.id }

      it "decrements course's user counter" do
        expect { subject }.to change { course.reload.users_count }.by(-1)
      end

      it 'deletes enrollment' do
        expect { subject }.to change { Enrollment.count }.by(-1)
      end
    end

    context 'when withdrawing fails' do
      let(:course) { create(:course, users_count: 1) }
      let(:enrollment_id) { 999_999 }

      it 'does not create enrollment' do
        expect { subject }.not_to change { Enrollment.count }
      end

      it "does not increment course's users counter" do
        expect { subject }.not_to change { course.reload.users_count }
      end
    end
  end
end
