module ApplicationHelper
  def is_active_controller(controller_name)
    @controller_without_namespace ||= params[:controller].split('/').last
    @controller_without_namespace == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  # options = {
  #   fixed:      true,     # general alerts types without dismissable
  #   icon:       'user',   # general alerts types with icon
  #   alert: {                # alert type
  #     fixed:    true,         # specific alert type without dismissable
  #     icon:     'flag',       # specific alert type with icon
  #     show:     true,         # show a specific alert type
  #     message:  'Hi!'         # display a message to a specific alert type
  #   }
  # }
  #
  # the available types are notice, alert, warning and info
  def flash_messages(options = {})
    options[:alert] ||= {}
    options[:notice] ||= {}
    options[:warning] ||= {}
    options[:info] ||= {}

    render partial: "flash_messages", locals: { options: options }
  end
end
