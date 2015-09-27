class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
  before_action :set_teacher_classroom_subjects, only: [:edit]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @teachers = scope_for_ng_table(Teacher)
                            .filter(params[:filter].try(:[], :general).to_s)
                            .by_status(params[:filter].try(:[], :status).to_s)
                            .by_gender(params[:filter].try(:[], :gender).to_s)
      end
    end
  end

  def update
    if params[:status].to_s.to_sym == :locked
      @teacher.lock
    elsif params[:status].to_s.to_sym == :approved
      @teacher.approve
    else
      @teacher.update(teacher_params)
    end

    respond_with :admin, @teacher
  end

  def destroy
    @teacher.disapprove
    respond_with @teacher, location: -> { admin_teachers_path }
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def set_teacher_classroom_subjects
    @teacher_classroom_subjects = @teacher.classrooms_subjects
                                    .joins(:classroom, :subject)
                                    .select('*, teacher_classroom_subjects.id')
  end

  def teacher_params
    params
      .require(:teacher)
      .permit(classrooms_subjects_attributes: [:id, :classroom_id, :subject_id, :_destroy])
  end
end
