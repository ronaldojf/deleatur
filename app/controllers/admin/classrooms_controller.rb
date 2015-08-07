class Admin::ClassroomsController < Admin::BaseController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @classrooms = scope_for_ng_table(Classroom)
                            .filter(params[:filter].try(:[], :general).to_s)
      end
    end
  end

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.save
    respond_with :admin, @classroom
  end

  def update
    @classroom.update(classroom_params)
    respond_with :admin, @classroom
  end

  def destroy
    @classroom.destroy
    respond_with @classroom, location: -> { admin_classrooms_path }
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params
      .require(:classroom)
      .permit(:identifier)
  end
end
