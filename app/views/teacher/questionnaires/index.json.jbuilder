json.set! :result do
  json.array!(@questionnaires) do |questionnaire|
    json.extract! questionnaire, :id, :title, :published, :updated_at

    json.set! :classroom, { identifier: questionnaire.classroom.try(:identifier) }
    json.set! :subject, { description: questionnaire.subject.try(:description) }

    json.show_html_url url_for([:teacher, questionnaire])
  end
end

json.set! :total, @questionnaires.total_count
