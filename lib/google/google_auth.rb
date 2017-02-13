require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'json'
OOB_URI     = 'urn:ietf:wg:oauth:2.0:oob'
USER_ID     = 100000
FILE_CREDS  = 'credentials.json'
SCOPE       = 'https://www.googleapis.com/auth/analytics.readonly'
FILE_TOKEN  = 'tokens.yaml'
AUTHORIZER  = Google::Auth::UserAuthorizer.new(
  Google::Auth::ClientId.from_file(FILE_CREDS), SCOPE,
  Google::Auth::Stores::FileTokenStore.new(file: FILE_TOKEN)
)
# Set the code, very first time
def set_code(code)
  credentials = AUTHORIZER.get_and_store_credentials_from_code(
    user_id: USER_ID, code: code, base_url: OOB_URI
  )
  credentials.refresh_token
end

# Fetches from store
def refresh_token
  credentials = AUTHORIZER.get_credentials(USER_ID)
  if credentials.nil?
    url = AUTHORIZER.get_authorization_url(base_url: OOB_URI )
    puts "Open #{url} in your browser and enter the resulting code:"
    nil
  else
    credentials.refresh_token
  end
end

# Generates and returns the access_token
def access_token
  creds = JSON.parse(File.read(FILE_CREDS))
  authorization = Google::Auth::UserRefreshCredentials.new(
       client_id: creds['installed']['client_id'],
       client_secret: creds['installed']['client_secret'],
       scope: SCOPE,
       refresh_token: refresh_token,
       expires_at: (Time.now+100).utc,
       grant_type: 'authorization_code')
  authorization.fetch_access_token!
  authorization.access_token
end
