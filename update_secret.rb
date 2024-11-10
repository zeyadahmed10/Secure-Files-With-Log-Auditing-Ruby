require 'json'

# Path to your JSON file
file_path = './config/import/realm-export.json'

# Fetch the new clientId value from an environment variable
new_client_secret = ENV['rb_kc_secret']

# Check if the environment variable is set
if new_client_secret.nil? || new_client_secret.empty?
  puts "Environment variable 'rb_kc_secret' is not set or is empty."
  exit(1)
end

# Load the JSON data from the file
data = JSON.parse(File.read(file_path))

# Find and update the clientId for the client with clientId 'rest-admin-client'
if data['clients']
  client = data['clients'].find { |c| c['clientId'] == 'rest-admin-client' }
  if client
    client['secret'] = new_client_secret
    puts "Updated client secret for 'rest-admin-client'."
  else
    puts "Client with clientId 'rest-admin-client' not found."
  end
else
  puts "'clients' key not found in JSON file."
end

# Write the updated data back to the JSON file
File.write(file_path, JSON.pretty_generate(data))
puts "File updated successfully."
