require 'spec_helper'

describe Tournament do
  before :each do
    @user = create(:user)
    @admin = create(:user, admin: true)
  end

  describe 'creatable?' do
    context 'admin' do
      it 'should be true with less than 3 tournaments' do
        create(:tournament, user:@admin)
        expect(@admin.creatable?).to be_true
      end

      it 'should be true with more than 3 tournaments' do
        5.times do
          create(:tournament, user:@admin)
        end
        expect(@admin.creatable?).to be_true
      end
    end
  end
end
