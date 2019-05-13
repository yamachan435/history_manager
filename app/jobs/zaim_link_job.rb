class ZaimLinkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Rails.logger.info 'Linking start'
    History.unlinked.each do |history|
      history.link
    end
    Rails.logger.info 'Linking end'
  end
end
