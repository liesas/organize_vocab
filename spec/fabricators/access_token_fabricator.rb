Fabricator(:access_token, from: 'Doorkeeper::AccessToken') do
  resource_owner_id 1
  application
  expires_in { 2.hours }
  refresh_token 'dummy_refresh_token'
end
