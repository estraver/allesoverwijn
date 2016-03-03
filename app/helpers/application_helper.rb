module ApplicationHelper
  def form_concept(concept)
    concept("#{concept}/cell/form", @model, form: @form)
  end

  def alert_class(flash_type)
    { success: 'alert-success',
      error:   'alert-danger',
      alert:   'alert-warning',
      notice:  'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def glyphicon_class(flash_type)
    { success: 'glyphicon-ok-sign',
      error:   'glyphicon-exclamation-sign',
      alert:   'glyphicon-warning-sign',
      notice:  'glyphicon-info-sign'
    }[flash_type.to_sym] || ''
  end

end
