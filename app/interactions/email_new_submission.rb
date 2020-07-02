class EmailNewSubmission < ActiveInteraction::Base
  object :submission
  object :user

  def execute
    email = SubmissionMailer.new_submission_confirmation_email submission

    CommunicationLog.log_submission_email(email, CommunicationLog::DEFAULT_DELIVERY_STATUS, submission, nil, user)

    email.deliver_now
  end
end
