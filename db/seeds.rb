c = ClientType.new name: 'Distribuidor'
c.id = 1
c.save!

c = ClientType.new name: 'Ferretería'
c.id = 2
c.save!

ClientType.create name: 'Usuario'
c.id = 3
c.save!

ClientType.create name: 'Representante'
c.id = 4
c.save!

ClientType.create name: 'Vendedor'
c.id = 5
c.save!
