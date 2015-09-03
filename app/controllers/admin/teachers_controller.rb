class Admin::TeachersController < Admin::BaseController
  before_action :set_teacher, only: [:show, :update, :destroy]

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
    (params[:status] == 'locked') ? @teacher.lock : @teacher.approve
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
end
