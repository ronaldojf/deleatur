json.set! :result do
  json.array!(@questionnaires) do |questionnaire|
    json.extract! questionnaire, :id, :title, :subject_id, :teacher_id, :updated_at, :status, :points

    json.set! :teacher, { name: questionnaire.teacher.name }
    json.set! :subject, { description: questionnaire.subject.description }

    json.show_html_url url_for(questionnaire)
  end
end

json.set! :total, @questionnaires.total_count
