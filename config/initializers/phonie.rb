Phonie.configure do |c|
  c.default_country_code = '55'
  c.n1_length = 4
  c.add_custom_named_format :'pt-BR', '(%a) %f-%l'
end