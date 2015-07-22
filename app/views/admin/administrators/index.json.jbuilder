json.set! :result do
  json.array!(@administrators) do |administrator|
    json.extract! administrator, :id, :name, :email

    json.show_html_url url_for([:admin, administrator])
  end
end

json.set! :total, @administrators.total_count