require 'rails_helper'

describe User do
  describe 'validations' do
    let!(:user) { create(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
