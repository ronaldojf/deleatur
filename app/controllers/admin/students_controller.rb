class Admin::StudentsController < Admin::BaseController
  before_action :set_student, only: [:show, :update, :destroy]

  def index
    #Separar código repetido
    respond_to do |format|
      format.html { render :index }
      format.json do
        @students = scope_for_ng_table(Student)
                            .includes(:classroom)
                            .references(:all)
                            .filter(params[:filter].try(:[], :general).to_s)
                            .in_classroom(params[:filter].try(:[], :classroom).to_s)
      end
    end
  end

  def update
    (params[:status] == 'locked') ? @student.lock : @student.unlock
    #Atualizar turma
    respond_with :admin, @student
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end
end
