require 'spec_helper'

RSpec.describe Campaign::Survey::Question::Option, type: :model do
  it 'is invalid without a conditional' do
    expect(build(:option, conditional: nil)).not_to be_valid
  end
  it 'is invalid without a conditional_question if conditional is skip' do
    expect(build(:option,
                 conditional: :skip,
                 conditional_question: nil)).not_to be_valid
  end
  it 'is destroyed when question is destroyed' do
    @option = create(:option)
    @option.question.destroy!
    expect { @option.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'generates a unique code' do
    @option = create(:option)
    expect(@option.code).to eq(Base62.encode(@option.id))
  end
  it 'creates a translation object when title is set' do
    @option = create(:option)
    expect(@option.translations.where(field: :title,
                                      content: @option.title)
      ).to exist
  end
end
