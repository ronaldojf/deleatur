json.set! :result do
  json.array!(@subjects) do |subject|
    json.extract! subject, :id, :description

    json.show_html_url url_for([:admin, subject])
  end
end

json.set! :total, @subjects.total_count