namespace :send_digest do
  desc 'Send digest daily'
  task run: :environment do
    DailyDigestJob.perform_later
  end
end