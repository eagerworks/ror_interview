puts "🌱 Generating development environment seeds."

team = Team.create(name: 'eagerworks')
user = User.create(email: 'admin@example.com', password: 'eagerInt!')
team.users << user

Projects::Tag.create(team: team, name: 'archived')
new_tag = Projects::Tag.create(team: team, name: 'new')

Project.create(team: team, name: 'HeartOut', created_at: Time.now - 7.months)
planit = Project.create(team: team, name: 'Planit', created_at: Time.now - 7.months)
Project.create(team: team, name: 'Opciones', tag_ids: [new_tag.id])

Invoice.create(team: team, project: planit, description: 'Software development services', total: 2000)
