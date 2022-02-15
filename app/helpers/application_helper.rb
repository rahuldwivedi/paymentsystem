module ApplicationHelper

  def display_date(date)
    return '' unless date
    date.strftime("%d-%B-%y %T")
  end
end
