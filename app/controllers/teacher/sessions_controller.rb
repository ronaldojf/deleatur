class Teacher::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(resource_or_scope)
    teacher_root_path
  end
end
