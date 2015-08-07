json.set! :result do
  json.array!(@classrooms) do |classroom|
    json.extract! classroom, :id, :identifier

    json.show_html_url url_for([:admin, classroom])
  end
end

json.set! :total, @classrooms.total_count