class Teacher::ClassroomsAndSubjectsController < Teacher::BaseController
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
    params
      .require(:teacher)
      .permit(classrooms_subjects_attributes: [:id, :classroom_id, :subject_id, :_destroy])
  end
end