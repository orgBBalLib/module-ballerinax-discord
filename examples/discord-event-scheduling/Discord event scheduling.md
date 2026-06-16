# Discord Event Scheduling

This example demonstrates how to automate Discord server event management by initializing a Discord client, retrieving guilds the bot has access to, creating a scheduled event, and confirming the event details.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token.

2. **Configuration**

   Create a `Config.toml` file in the project root directory with your Discord bot credentials:

   ```toml
   botToken = "<Your Discord Bot Token>"
   ```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the guilds retrieved, event creation details, and confirmation of the scheduled event.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Server Event Management ===

✓ Discord client initialized successfully

Step 1: Retrieving guilds the bot has access to...
Found 2 guild(s):
  - Gaming Community (ID: 123456789012345678)
  - Developer Hub (ID: 987654321098765432)

Step 2: Creating a scheduled event in the first guild...
Event details to create:
  - Name: Weekly Game Night
  - Description: Join us for our weekly community game night!...
  - Entity Type: External Event
  - Privacy Level: Guild Only

✓ Event created successfully!
  - Event ID: 111222333444555666

Step 3: Fetching event details to confirm creation...

=== Event Confirmation ===
Guild: Gaming Community (ID: 123456789012345678)
Event ID: 111222333444555666
Event Name: Weekly Game Night
...

✓ Event management workflow completed successfully!
```