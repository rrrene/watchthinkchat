require 'spec_helper'

RSpec.describe Campaign::Survey::Question, type: :model do
  it 'is invalid without survey' do
    expect(build(:question, survey: nil)).not_to be_valid
  end
  it 'is invalid without title' do
    expect(build(:question, title: nil)).not_to be_valid
  end
  it 'is destroyed when survey is destroyed' do
    @question = create(:question)
    @question.survey.destroy!
    expect { @question.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'generates a unique code' do
    @question = create(:question)
    expect(@question.code).to eq(Base62.encode(@question.id))
  end
  it 'creates a translation object when title is set' do
    @question = create(:question)
    expect(@question.translations.where(field: :title,
                                        content: @question.title)
      ).to exist
  end
  it 'creates a translation object when help_text is set' do
    @question = create(:question)
    expect(@question.translations.where(field: :help_text,
                                        content: @question.help_text)
      ).to exist
  end
end
