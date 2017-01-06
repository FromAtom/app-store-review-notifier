class ReviewEntry
  attr_reader :id

  def initialize(entry)
    @id = (entry.dig('id', 'label') || '').to_s
    @title = (entry.dig('title', 'label') || '').gsub(/'/, "’").gsub(/"/, '\"')
    @name = (entry.dig('author', 'name', 'label') || 'unknown').gsub(/'/, "’").gsub(/"/, '\"')
    @comment = (entry.dig('content', 'label') || 'nothing').gsub(/'/, "’").gsub(/"/, '\"')
    @rating = (entry.dig('im:rating', 'label') || 5).to_i
    @rating_label = ':star:' * @rating
    @colorName = getColorName(@rating)
  end

  def hash_for_slack
    hash = {
      :id => @id,
      :fallback => @comment,
      :author_name => @name,
      :title => @title,
      :text => @comment,
      :color => @colorName,
      :fields => [
        {
          :title =>'Rating',
          :value => @rating_label,
          :short => 'false'
        }
      ]
    }

    return hash
  end

  private
  def getColorName(rating)
    if rating <= 2
      return 'danger'
    elsif rating <= 3
      return 'warning'
    else
      return 'good'
    end
  end
end
