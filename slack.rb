class Slack
  def initialize(slack_url)
    @slack_url = URI.parse(slack_url)
  end

  def send(entries)
    if entries.empty?
      puts '[LOG] New Review is nothing.'
      return
    end

    attachments = createAttachments(entries)
    payload = createPayload(attachments)
    response = Net::HTTP.post_form(@slack_url, { 'payload' => payload })
    puts response.body
  end

  private
  def createAttachments(entries)
    attachments = []

    entries.each do |entry|
      hash = entry.hash_for_slack
      attachments.push(hash)
    end

    return attachments
  end

  def createPayload(attachments)
    payload = {
      :icon_emoji => ':star:',
      :attachments => attachments
    }.to_json.encode

    return payload
  end

end
