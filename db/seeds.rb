unless Administrator.where(main: true).exists?
  puts "=> Inserting a Main Administrator".blue
  Administrator.create name: 'Administrador', email: 'teste@teste.com.br', password: '12345678'
end