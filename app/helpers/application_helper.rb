module ApplicationHelper
  def full_title page_title = ""
    base_title = t "header"

    return if page_title.empty?
    page_title + " | " + base_title
  end
end
