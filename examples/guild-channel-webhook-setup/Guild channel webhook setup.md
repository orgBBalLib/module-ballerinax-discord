# Guild Channel Webhook Setup

This example demonstrates how to automate Discord guild channel management by retrieving existing channels, creating a new announcement channel, and setting up a webhook for external service notifications.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with the following configuration:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild ID>"
   ```

   | Configuration     | Description                                                    |
   |-------------------|----------------------------------------------------------------|
   | `discordBotToken` | The bot token obtained from the Discord Developer Portal       |
   | `guildId`         | The ID of the Discord guild (server) where channels will be managed |

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Channel Management Automation ===

Step 1: Retrieving all channels in the guild...
Found 5 channels in the guild:
  - Channel: general (ID: 123456789, Type: 0)
  ...

Step 2: Creating a new announcement channel...
Successfully created announcement channel:
  - Name: important-announcements
  - ID: 987654321
  - Type: 5

Step 3: Setting up a webhook for external service notifications...
Successfully created webhook:
  - Name: External Notifications Bot
  - ID: 111222333
  - Webhook URL: https://discord.com/api/webhooks/...
  - Token: abc123...

=== Automation Complete ===
```