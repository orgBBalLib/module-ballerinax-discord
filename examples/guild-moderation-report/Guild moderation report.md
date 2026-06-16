# Guild Moderation Report

This example demonstrates how to generate a comprehensive moderation report for a Discord guild by checking ban statuses for specified users and posting the compiled report to an admin channel via webhook.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token, guild ID, webhook ID, and webhook token.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your Discord credentials:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild ID>"
   webhookId = "<Your Webhook ID>"
   webhookToken = "<Your Webhook Token>"
   userIdsToCheck = ["123456789012345678", "234567890123456789", "345678901234567890"]
   ```

   | Configuration     | Description                                              |
   |-------------------|----------------------------------------------------------|
   | `discordBotToken` | Bot token for Discord API authentication                 |
   | `guildId`         | The ID of the Discord guild to audit                     |
   | `webhookId`       | The ID of the webhook for posting reports                |
   | `webhookToken`    | The token associated with the webhook                    |
   | `userIdsToCheck`  | Array of user IDs to check for ban status                |

## Run the Example

Execute the following command to run the example. The script will check ban statuses for the specified users, compile a moderation report, and attempt to post it via the configured webhook.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Audit and Moderation Report Generator ===

Discord client initialized successfully.

--- Step 1: Retrieving Ban Information ---
  ○ No ban found for user 123456789012345678
  ✓ Found ban for user 234567890123456789: username
    Reason: Violation of server rules

Total active bans found: 1

--- Step 2: Compiling Moderation Report ---
Moderation report compiled successfully.

...

=== Moderation Report Generation Complete ===
```