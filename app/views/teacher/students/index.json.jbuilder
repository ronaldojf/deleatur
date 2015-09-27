json.set! :result do
  json.array!(@students) do |student|
    json.extract! student, :id, :name, :gender, :email, :cpf, :phone, :birth_date, :status
    json.classroom student.classroom.identifier

    json.show_html_url url_for([:teacher, student])
  end
end

json.set! :total, @students.total_count