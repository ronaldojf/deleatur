class Student::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(resource_or_scope)
    student_root_path
  end
end
