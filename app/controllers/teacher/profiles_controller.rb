class Teacher::ProfilesController < Teacher::BaseController
  before_action :set_teacher_classroom_subjects

  def update
    current_user.update(teacher_params)
    respond_with current_user, location: -> { teacher_root_path }
  end

  private

  def set_teacher_classroom_subjects
    @teacher_classroom_subjects = current_user.classrooms_subjects
                                    .joins(:classroom, :subject)
                                    .select('*, teacher_classroom_subjects.id')
  end

  def teacher_params
    params[:teacher].except!(:password, :current_password, :password_confirmation) if params[:teacher][:password].blank?

    params
      .require(:teacher)
      .permit(:name, :gender, :cpf, :phone, :birth_date, :email,
              :password, :current_password, :password_confirmation,
              classrooms_subjects_attributes: [:id, :classroom_id, :subject_id, :_destroy])
      .merge({validate_current_password: true})
  end
end