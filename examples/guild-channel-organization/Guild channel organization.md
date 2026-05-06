# Guild Channel Organization

This example demonstrates how to organize Discord guild channels by fetching existing channels, creating a new announcements channel, and displaying comprehensive channel statistics for your server.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and guild ID.

2. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing channel information, creation status, and statistics.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Channel Organization and Announcement System ===

Step 1: Fetching all existing channels in the guild...
Found X channels in the guild:
  - Channel: general (ID: 123456789, Type: 0)
  ...

Step 2: Creating a new announcements channel...
Successfully created announcements channel!
  - Channel Name: server-announcements
  - Channel ID: 987654321
  ...

Step 3: Channel Organization Summary
=====================================
Total channels before: X
New channel created: server-announcements
...

=== Guild Channel Organization Complete ===
```