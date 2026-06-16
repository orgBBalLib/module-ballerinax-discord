# Guild Channel Cleanup Workflow

This example demonstrates how to automate Discord guild channel analysis and cleanup workflows using the Ballerina Discord connector. The script retrieves all channels in a guild, categorizes them by type, analyzes user engagement through message reactions, and provides recommendations for channel archival and cleanup.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a Discord bot application and obtain your bot token.

2. **Gather Required IDs**
   - Enable Developer Mode in Discord (User Settings → App Settings → Advanced → Developer Mode)
   - Right-click on your server to copy the Guild ID
   - Right-click on a channel to copy the Channel ID
   - Right-click on a message to copy the Message ID

3. **Configuration**
   
   Create a `Config.toml` file in the project root directory with the following configuration:

   ```toml
   botToken = "<Your Bot Token>"
   guildId = "<Your Guild ID>"
   targetChannelId = "<Your Target Channel ID>"
   targetMessageId = "<Your Target Message ID>"
   emojiName = "<Emoji Name>"
   ```

   | Configuration      | Description                                                                 |
   |--------------------|-----------------------------------------------------------------------------|
   | `botToken`         | Your Discord bot token for authentication                                   |
   | `guildId`          | The ID of the Discord server (guild) to analyze                             |
   | `targetChannelId`  | The channel ID containing the message to check for reactions                |
   | `targetMessageId`  | The message ID to analyze for user reactions                                |
   | `emojiName`        | The emoji to check for reactions (e.g., "👍" or a custom emoji name)        |

## Run the Example

Execute the following command to run the example. The script will analyze your guild's channels and print a detailed report to the console.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Channel Cleanup and Archival Workflow ===

Step 1: Retrieving all channels in the guild...
Found 15 channels in the guild.

Channel Analysis Report:
------------------------
  - [Text] general (ID: 123456789012345678)
  - [Voice] Voice Chat (ID: 234567890123456789)
  ...

Channel Summary:
  Text Channels: 8
  Voice Channels: 3
  Categories: 2
  Threads: 2
  Other: 0

------------------------
Step 2: Analyzing channel activity via message reactions...
...

------------------------
Step 3: Cleanup and Archival Recommendations
...

=== Workflow Complete ===
```