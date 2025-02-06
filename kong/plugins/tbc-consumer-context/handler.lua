local kong = kong

local plugin = {
    PRIORITY = 1000,
    VERSION = "0.1",
}
  
function plugin:access(plugin_conf)
    kong.log.inspect(plugin_conf) 
    local consumer_name = kong.request.get_header(plugin_conf.consumer_header_name)
    local consumer_credentials = kong.request.get_header(plugin_conf.consumer_credentials_header_name)
    
    -- Load the consumer entity
    local consumer_entity = kong.client.load_consumer(consumer_name, true)
    if not consumer_entity then
        return kong.response.exit(401, { message = "Unauthorized: Consumer not found" })
    end
    kong.log.info("Loaded Consumer: ", kong.log.inspect(consumer_entity))

    -- Load the credential entity from Kong's datastore
    local credential_entity, err = kong.db.keyauth_credentials:select_by_key(consumer_credentials)
    if not credential_entity then
        return kong.response.exit(401, { message = "Unauthorized: Invalid credentials" })
    end
    kong.log.info("Loaded Credential: ", kong.log.inspect(credential_entity))

    -- Authenticate the consumer
    kong.client.authenticate(consumer_entity, credential_entity)
    kong.log.info("Consumer authenticated successfully.")
end

return plugin