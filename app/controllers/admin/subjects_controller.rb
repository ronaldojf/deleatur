class Admin::SubjectsController < Admin::BaseController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @subjects = scope_for_ng_table(Subject)
                            .filter(params[:filter].try(:[], :general).to_s)
      end
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.save
    respond_with :admin, @subject
  end

  def update
    @subject.update(subject_params)
    respond_with :admin, @subject
  end

  def destroy
    @subject.destroy if current_user.main?
    respond_with @subject, location: -> { admin_subjects_path }
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params
      .require(:subject)
      .permit(:description)
  end
end
