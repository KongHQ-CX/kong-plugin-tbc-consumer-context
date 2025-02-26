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
          { konnect_applicationId_header_name = typedefs.header_name {
              required = true,
              default = "x-application-id" } }
        },
      },
    },
  },
}

return schema