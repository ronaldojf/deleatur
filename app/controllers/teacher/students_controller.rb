class Teacher::StudentsController < Teacher::BaseController
  before_action :set_student, only: [:show, :update, :edit, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        from_table = current_user.students
                        .select('students.*, SUM(COALESCE(pontuations.points, 0)) AS points')
                        .joins{pontuations.outer}
                        .filter(params[:filter].try(:[], :general).to_s)
                        .in_classroom(params[:filter].try(:[], :classroom).to_s)
                        .by_status(params[:filter].try(:[], :status).to_s)
                        .by_gender(params[:filter].try(:[], :gender).to_s)
                        .group(:id)

        @students = scope_for_ng_table(current_user.students)
                            .from("(#{from_table.to_sql}) AS students")
                            .includes(:classroom)
      end
    end
  end

  def update
    @student.update(student_params)
    respond_with :teacher, @student, location: -> { teacher_students_path }
  end

  private

  def set_student
    @student = current_user.students.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:classroom_id)
  end
end
