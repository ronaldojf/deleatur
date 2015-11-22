class Student::QuestionnairesController < Student::BaseController
  before_action :set_questionnaire, only: [:show, :answer, :update]
  before_action :set_answered, only: [:show, :answer]
  before_action :set_sorting, only: [:index]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @questionnaires = scope_for_ng_table(current_user.student_questionnaires)
                            .joins(:teacher, :subject)
                            .preload(:teacher, :subject)
                            .filter(params[:filter].try(:[], :general).to_s)
                            .by_subject(params[:filter].try(:[], :subject).to_s)
                            .by_status(params[:filter].try(:[], :status).to_s)
      end
    end
  end

  def show
    unless @answered.pending?
      service = AnsweredQuestionnaireService.new(@answered)
      @wrong_answer_indexes = service.wrong_indexes_of(@questionnaire).collect { |index| index + 1 }
    end
  end

  def update
    answered_questionnaire = current_user.answered_questionnaires.find_or_initialize_by(questionnaire_id: params[:id])
    @answered_service = AnsweredQuestionnaireService.new(answered_questionnaire)

    begin
      @answered_service.update!(answered_questionnaire_params)

      if answered_questionnaire.pontuation.generate_extra_points
        flash[:notice_extra_points] = I18n.t('infos.earned_extra_points', points: Pontuation::EXTRA_POINTS)
      end

      respond_with @answered_service.answered_questionnaire, location: -> { questionnaire_path(@questionnaire) }
    rescue
      flash[:alert] = I18n.t('errors.custom_messages.saving_questionnaire')
      redirect_to answer_questionnaire_path(@questionnaire)
    end
  end

  private

  def set_questionnaire
    @questionnaire = current_user.questionnaires.find(params[:id])
  end

  def set_answered
    @answered = current_user.answered_questionnaires.find_or_initialize_by(questionnaire_id: params[:id])
  end

  def answered_questionnaire_params
    params
      .require(:answered_questionnaire)
      .permit(answers_attributes: [:id, :chosed, :question_option_id, :_destroy])
  end

  def set_sorting
    @config[:sorting] = {'questionnaires.updated_at': :desc} if @config[:sorting].blank?
  end
end
