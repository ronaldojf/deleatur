module ApplicationHelper
  def flash_messages
    render partial: "flash_messages"
  end

  def is_active_controller(controller_name)
    @controller_without_namespace ||= params[:controller].split('/').last
    @controller_without_namespace == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end
end
