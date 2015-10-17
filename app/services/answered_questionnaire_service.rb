class AnsweredQuestionnaireService
  attr_reader :answered_questionnaire

  def initialize(answered_questionnaire)
    @answered_questionnaire = answered_questionnaire
  end

  def update(params)
    self.update!(params) rescue nil
  end

  def update!(params)
    params = clean_params(params)
    @answered_questionnaire.assign_attributes(params)

    @answered_questionnaire.transaction do
      pending = @answered_questionnaire.pending?
      @answered_questionnaire.status = :answered if pending

      @answered_questionnaire.save!

      generate_pontuation! if pending
    end
  end

  private

  def generate_pontuation!
    @answered_questionnaire.create_pontuation(student_id: @answered_questionnaire.student_id)
  end

  def clean_params(params)
    params[:answers_attributes].select! { |answer| answer[:chosed] == 'on' || answer[:id].present? }

    params[:answers_attributes].collect! do |answer|
      chosed = answer.delete(:chosed) == 'on'

      if answer[:id].present?
        chosed ? answer : answer.merge({_destroy: '1'})
      else
        answer
      end
    end

    params
  end
end
