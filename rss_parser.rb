class RSSParser
  def initialize(url)
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    @result = JSON.parse(json)
  end

  def modelize
    # 最初のエントリーはアプリ情報なので削除
    row_entries = (@result.dig('feed', 'entry') || []).drop(1)

    review_entries = []
    row_entries.each do |row_entry|
      entry = ReviewEntry.new(row_entry)
      review_entries.push(entry)
    end

    return review_entries
  end
end
