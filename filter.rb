class Filter
  def initialize(redis_url, redis_key)
    @redis = Redis.new(:url => redis_url)
    @redis_key = redis_key
    json = @redis.get(redis_key) || '[]'
    @exist_ids = JSON.parse(json)
  end

  def filter(entries)
    ap @exist_ids
    filtered_entries = []
    entries.each do |entry|
      next if @exist_ids.include?(entry.id)

      @exist_ids.push(entry.id)
      @exist_ids.shift if @exist_ids.length > 400 #ひとまず400件ぐらいでええじゃろ

      filtered_entries.push(entry)
    end

    saveToRedis

    return filtered_entries
  end

  private
  def saveToRedis
    json = @exist_ids.to_json
    @redis.set(@redis_key, json)
  end
end
