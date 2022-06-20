class SphinxFinder
  def initialize(params)
    @type = params[:type]
    @query = params[:query]
    @result = nil
  end

  def call
    return unless valid?
    find_by_query
    @result
  end

  private

  def valid?
    @type.present? && @query.present?
  end

  def sanitize_query
    ThinkingSphinx::Query.escape(@query)
  end

  def find_by_query
    @result = case @type
      when 'all'
        ThinkingSphinx.search sanitize_query, per_page: 1000
      when 'questions'
        Question.search sanitize_query, per_page: 1000
      when 'answers'
        Answer.search sanitize_query, per_page: 1000
      when 'comments'
        Comment.search sanitize_query, per_page: 1000
      when 'users'
        User.search sanitize_query, per_page: 1000
      end

    @result = @result.group_by { |el| el.class.name.downcase } unless @result.nil?
  end
end