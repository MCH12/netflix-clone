module ApplicationHelper
  def review_rating_options(current_rating=nil)
    options_for_select((1..5).map { |num| [pluralize(num, 'Star'), num]}, current_rating)
  end
end
