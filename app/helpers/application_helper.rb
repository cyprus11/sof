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

  def collection_cash_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at)&.utc.to_i
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def resource_cash_for(resource, user)
    klass_name = resource.class.name.downcase
    "#{klass_name}/user-#{user.id}-#{resource.id}-#{resource.updated_at}"
  end
end
