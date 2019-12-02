require 'rails_helper'

describe Employee do
  describe 'validations' do
    let!(:employee) { create(:employee) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
