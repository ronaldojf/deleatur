class Student::AnsweredQuestionnairesController < Student::BaseController
  before_action :set_answered, only: [:update]

  def update
    @answered.update(status: params[:status]) if %w(answered fixed).include?(params[:status])
    redirect_to questionnaire_path(@answered.questionnaire)
  end

  private

  def set_answered
    @answered = current_user.answered_questionnaires.find(params[:id])
  end
end
