module ApplicationHelper
  def flash_messages(options = {})
    options[:alert] ||= {}
    options[:notice] ||= {}
    options[:warning] ||= {}
    options[:info] ||= {}

    render partial: "flash_messages", locals: { options: options }
  end

  def is_active_controller(controller_name)
    @controller_without_namespace ||= params[:controller].split('/').last
    @controller_without_namespace == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end
end
