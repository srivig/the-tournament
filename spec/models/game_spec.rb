require 'spec_helper'

describe Tournament do
  it 'is valid with a proper attrs' do
    tournament = Tournament.new(
      user_id: 1,
      size: 4,
      title: 'hogehoge'
    )
    expect(tournament).to be_valid
  end
end
