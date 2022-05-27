module ApplicationHelper
  def flash_types(type)
    case type
    when 'notice'
      'info'
    when 'success'
      'success'
    when 'error', 'alert'
      'danger'
    else
      'warning'
    end
  end
end
