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

  def wrong_indexes_of(questionnaire)
    right_options = get_right_options_count_of(questionnaire)
    right_answers = get_right_answers_count

    options = default_right_options_in_question_indexes_of(questionnaire)
    answers = options.dup

    right_options.each { |option| options[option.index] = option.right_options_count }
    right_answers.each do |answer|
      answers[answer.index] = (answer.wrong_options_count > 0) ? (answer.wrong_options_count * -1) : answer.right_options_count
    end

    options.select do |index, count|
      answers[index] != count || (answers[index].zero? && !count.zero?)
    end.keys
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

  def get_right_options_count_of(questionnaire)
    questionnaire.options
      .right
      .select('questions.index, SUM(CASE WHEN question_options.right THEN 1 ELSE 0 END) AS right_options_count')
      .group('questions.index')
      .reorder('')
  end

  def get_right_answers_count
    self.answered_questionnaire.answers
      .joins(question_option: :question)
      .select('questions.index,
                SUM(CASE WHEN question_options.right THEN 1 ELSE 0 END) AS right_options_count,
                SUM(CASE WHEN question_options.right THEN 0 ELSE 1 END) AS wrong_options_count')
      .group('questions.index')
  end

  def default_right_options_in_question_indexes_of(questionnaire)
    (0..(questionnaire.questions.count - 1)).to_a.collect do |index|
      {index => 0}
    end.inject(&:merge)
  end
end
