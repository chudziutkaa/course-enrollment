require 'rails_helper'

describe User do
  it { is_expected.to define_enum_for(:role).with_values(worker: 1, student: 0) }

  describe 'validations' do
    let!(:user) { create(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
