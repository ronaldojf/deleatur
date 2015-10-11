class Teacher::QuestionnairesController < Teacher::BaseController
  before_action :set_questionnaire, only: [:show, :duplicate]
  before_action :set_not_published_questionnaire, only: [:edit, :update, :destroy, :publish]
  before_action :set_classroom, only: [:create, :update]
  before_action :set_subject, only: [:create, :update]
  before_action :set_sorting, only: [:index]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @questionnaires = scope_for_ng_table(current_user.questionnaires)
                            .includes(:classroom, :subject)
                            .filter(params[:filter].try(:[], :general).to_s)
                            .by_publication(params[:filter].try(:[], :published).to_s)
                            .by_classroom(params[:filter].try(:[], :classroom).to_s)
                            .by_subject(params[:filter].try(:[], :subject).to_s)
      end
    end
  end

  def new
    @questionnaire = current_user.questionnaires.build
  end

  def create
    @questionnaire = current_user.questionnaires.build(questionnaire_params)
    @questionnaire.save
    respond_with :teacher, @questionnaire
  end

  def update
    @questionnaire.update(questionnaire_params)
    respond_with :teacher, @questionnaire
  end

  def destroy
    @questionnaire.destroy
    respond_with @questionnaire, location: -> { teacher_questionnaires_path }
  end

  def publish
    @questionnaire.update(published: true)

    path = if @questionnaire.errors.empty?
      teacher_questionnaire_path(@questionnaire)
    else
      edit_teacher_questionnaire_path(@questionnaire)
    end

    respond_with @questionnaire, location: -> { path }
  end

  private

  def set_questionnaire
    @questionnaire = current_user.questionnaires.find(params[:id])
  end

  def set_not_published_questionnaire
    @questionnaire = current_user.questionnaires.not_published.find(params[:id])
  end

  def set_classroom
    if params[:questionnaire].try(:[], :classroom_id).present?
      @classroom = current_user.classrooms.find(params[:questionnaire][:classroom_id])
    end
  end

  def set_subject
    if params[:questionnaire].try(:[], :subject_id).present?
      @subject = current_user.subjects.for_classroom(@classroom).find(params[:questionnaire][:subject_id])
    end
  end

  def questionnaire_params
    params
      .require(:questionnaire)
      .permit(:title, :published, questions_attributes: [:id, :description, :index, :_destroy,
                        options_attributes: [:id, :description, :right, :_destroy]
      ]).merge(classroom_id: @classroom.try(:id), subject_id: @subject.try(:id))
  end

  def set_sorting
    @config[:sorting] = {'questionnaires.updated_at': :asc} if @config[:sorting].blank?
  end
end
