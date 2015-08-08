json.set! :result do
  json.array!(@teachers) do |teacher|
    json.extract! teacher, :id, :name, :gender, :email, :cpf, :phone, :birth_date, :status

    json.show_html_url url_for([:admin, teacher])
  end
end

json.set! :total, @teachers.total_count