class SendMailJob < ApplicationJob
  queue_as :default

  def perform(to, from, subject, body)
    # Do something later
    Mail.deliver do 
      to to
      from from
      subject subject
      body body
    end
  end
end
