# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_integration_session',
  :secret      => '3aad38b061dce3ae22d5d9834946179fbc06a3581d3d9921172df2adaa3a3433d0f901ffe708263e7ce4bf09e5fe7f4bdf8a90b533012077448851e0149cab75'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
