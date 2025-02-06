local typedefs = require "kong.db.schema.typedefs"


local PLUGIN_NAME = "tbc-consumer-context"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    { consumer = typedefs.no_consumer },  
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { consumer_header_name = typedefs.header_name {
              required = true,
              default = "appId" } },
          { consumer_credentials_header_name = typedefs.header_name {
              required = true,
              default = "appCredentials" } },

        },
      },
    },
  },
}

return schema