unless Administrator.where(main: true).exists?
  puts "=> Inserting a Main Administrator"
  Administrator.create name: 'Administrador', email: 'teste@teste.com.br', password: 'deleatur1234'
end