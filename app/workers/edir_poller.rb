require 'nokogiri'

class EdirPoller
  include Sidekiq::Worker

  RACKER_APP_ENDPOINT = "https://#{ENV["RACKER_APP_USERNAME"]}:#{ENV["RACKER_APP_PASSWORD"]}@rackerorg.api.rackspace.com:5181/service-desk/atom/feeds/terminations"

  # Needed for whenever integration
  def self.update_feed
    perform_async
  end

  def perform
    marker = nil
    most_recent_term = Termination.order("updated desc").first
    if most_recent_term.nil?
      logger.info "Starting eDir poll. No existing terminations available."
    else
      marker = most_recent_term.uuid
      logger.info "Starting eDir poll at marker #{marker}."
    end

    response = RestClient.get RACKER_APP_ENDPOINT, {:params => {:marker => marker, :limit => 250}, :content_type => :json, :accept => :json}
    feed = JSON.parse(response)
    entries = feed["feed"]["entries"]

    logger.info "#{entries.count} messages to be processed."
    entries.each do |e|
      logger.debug "Processing entry #{e['id']}, last updated #{e['updated']}"

      # skip the marker element since we've already parsed it
      if e['id'] == marker
        next
      end

      e["content"]["children"].each do |c|
        term_xml = Nokogiri::XML(c)
        term = Termination.new
        term.username = extract_value('username', term_xml)
        term.term_date = DateTime.parse extract_value('terminationDate', term_xml)
        term.fullname = extract_value('fullname', term_xml)
        term.manager = extract_value('manager', term_xml)
        term.location = extract_value('location', term_xml)
        term.processed_by = extract_value('terminationProcessedBy', term_xml)

        term.uuid = e["id"]
        term.updated = DateTime.parse e["updated"]
        term.save

        RemoveUser.remove term.username
      end
    end

    logger.info "eDir poll complete."
  end

  def extract_value(element_name, termination_xml)
    element = termination_xml.xpath("//xmlns:#{element_name}")

    if element.nil? or element.empty?
      logger.warning "Element #{element_name} not present in termination xml."
      nil
    else
      element.inner_text
    end
  end
end