local kong = kong

local plugin = {
    PRIORITY = 949,
    VERSION = "0.1",
}
  
function plugin:access(plugin_conf)
    --kong.log.inspect(kong.client.get_credential())

    -- keep the existing credential used to authenticate
    local existing_credential = kong.client.get_credential()
    if not existing_credential then
        return kong.response.exit(401, { message = "Unauthorized: Credential not found" })
    end
    --kong.log.inspect(kong.request.get_headers())
    --kong.log.inspect(plugin_conf) 
    
    -- read the x-application-id header which contains the Dev Portal ApplicationId
    local consumer_name = kong.request.get_header(plugin_conf.konnect_applicationId_header_name)
    --kong.log.notice('ConsumerName: ', consumer_name)
    
    -- Load the consumer entity with the same value as x-application-id
    local consumer_entity = kong.client.load_consumer(consumer_name, true)
    --kong.log.inspect(consumer_entity)
    if not consumer_entity then
        kong.log.info("No matching consumer for appplicationId: ", consumer_name)    
    --    return kong.response.exit(401, { message = "Unauthorized: Consumer not found" })
    else
        kong.log.info("Loaded Consumer: ", consumer_name)
        -- Authenticate the consumer using the located consumer and the existing_credential
        kong.client.authenticate(consumer_entity, existing_credential)
        kong.log.info("Consumer authenticated successfully.")
    end
end

return plugin