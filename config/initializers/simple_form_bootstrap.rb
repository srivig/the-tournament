SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-error'
  config.label_class = 'col-sm-2 control-label'
  config.input_class = "form-control"

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'form-group' do |ba|
      ba.use :input, wrap_with: { tag: 'div', class: 'col-sm-6' }
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com/2.3.2/)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
