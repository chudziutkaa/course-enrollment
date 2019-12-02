require 'rails_helper'

describe Enrollment do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:course) }
  end
end
