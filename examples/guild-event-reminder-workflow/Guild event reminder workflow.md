# Guild Event Reminder Workflow

This example demonstrates an automated guild event management system for Discord that checks scheduled events, identifies those happening within the next 24 hours, and posts reminder announcements to a designated channel.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. **Configuration**
   
   For this example, create a `Config.toml` file with your Discord credentials:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild ID>"
   announcementChannelId = "<Your Announcement Channel ID>"
   ```

   | Configuration Key        | Description                                              |
   |--------------------------|----------------------------------------------------------|
   | `discordBotToken`        | Your Discord bot's authentication token                  |
   | `guildId`                | The ID of the Discord guild (server) to monitor          |
   | `announcementChannelId`  | The channel ID where event reminders will be posted      |

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the event checking workflow and simulated reminder posting.

```shell
bal run
```

The script will:
1. Initialize the Discord client with bot token authentication
2. Fetch scheduled events from the guild (simulated)
3. Filter events happening within the next 24 hours
4. Post formatted reminder announcements for upcoming events (simulated)
5. Add attendance reaction emojis to posted messages (simulated)
6. Display a summary of the event management process

> **Note:** This example demonstrates the intended workflow structure with simulated data, as the Discord API definitions used do not include all necessary endpoints for guild scheduled events and message posting.