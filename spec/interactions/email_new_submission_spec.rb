require 'rails_helper'

RSpec.describe EmailNewSubmission do
  let(:user)       { create :user }
  let(:submission) { create :submission }

  subject(:interaction) { EmailNewSubmission.run! submission: submission, user: user }

  let(:last_email) { ActionMailer::Base.deliveries.last }
  let(:last_log)   { CommunicationLog.last }

  it 'sends an email' do
    expect { interaction }.to change(ActionMailer::Base.deliveries, :size).by(1)
    expect(last_email.to).to eq [submission.person.email]
  end

  it 'creates a CommunicationLog entry' do
    expect { interaction }.to change(CommunicationLog, :count).by(1)
    expect(last_log.person).to eq submission.person
    expect(last_log.created_by).to eq user
  end

  context 'when email delivery succeeds' do
    before { interaction }

    it 'saves the sent status in the log entry' do
      expect(last_log.delivery_status).to eq CommunicationLog::DEFAULT_DELIVERY_STATUS
    end
  end

  context 'when email delivery fails' do
    before { interaction }

    it 'marks the log entry as failed' #how?
  end
end
