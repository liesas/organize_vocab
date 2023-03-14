Fabricator(:application, from: 'Doorkeeper::Application') do
  name 'client'
  redirect_uri ''
end
