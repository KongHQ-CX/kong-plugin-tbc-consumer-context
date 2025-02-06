# TBC Consumer Context Plugin

This plugin enables seamless handling of consumer authentication and credential validation within Kong Gateway. After successfully authenticating an initial consumer using API keys, the plugin modifies the request context to reflect a different consumer. This allows subsequent processing—such as applying rate-limiting policies—to consider the updated consumer context.

---

## **Key Features**
- **Dynamic Consumer Context Switching:**  
  Validates the initial consumer using Key Authentication and then changes the request context to a different consumer.

- **Enhanced Authentication Flow:**  
  Utilizes Kong’s built-in mechanisms (`kong.client.load_consumer`, `kong.db.keyauth_credentials:select_by_key`) to fetch and validate consumer entities and their associated credentials.

- **Integration with Rate Limiting:**  
  By changing the consumer context, the plugin enables the application of rate limiting policies to the new consumer.

---

## **Execution Flow**

1. The request arrives with headers containing the consumer name and API key.
2. The plugin retrieves the consumer entity from Kong’s datastore using the provided consumer name.
3. It then fetches the credential entity using the API key.
4. If both the consumer and credential are valid, the plugin updates Kong’s context by calling `kong.client.authenticate()`.
5. The new consumer context is now active, allowing subsequent plugins (like rate limiting) to apply policies based on the updated consumer.

---

## **Configuration**

| Field Name                         | Type   | Description                                  | Default     |
|------------------------------------|--------|----------------------------------------------|-------------|
| `consumer_header_name`             | string | Header containing the initial consumer name. | `"appId"`   |
| `consumer_credentials_header_name` | string | Header containing the initial API key.       | `"appCredentials"` |

---

## **Execution Flow Diagram**

Below is a simple Markdown representation of the execution flow:
# Execution Flow Diagram

```plaintext
    Request
      │
      ▼
+-----------+
| Key Auth  |       --> (Valid API Key)
| Plugin    |       --> (Invalid API Key: 401 Unauthorized)
+-----------+
      │
      ▼
+-----------------+
| TBC-Consumer-  |       --> (Consumer Not Found: 401 Unauthorized)
| Context Plugin  |       --> (Valid Consumer)
+-----------------+
      │
      ▼
  Updated Context
      │
      ▼
+--------------------+
| Rate Limiting     |  
| (Consumer-Specific)|
+--------------------+
      │
      ▼
  Forward Request
