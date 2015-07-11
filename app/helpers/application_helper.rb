module ApplicationHelper
  def serialize_json_angular(obj)
    ret = obj
    ret = ret.to_json unless obj.is_a?(String)
    ret.gsub(/[']/,"\\\\\'")
  end

  def flash_messages
    render partial: "flash_messages"
  end
end
