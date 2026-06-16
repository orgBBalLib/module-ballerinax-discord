# Guild Emoji Management

This example demonstrates how to manage Discord guild emojis by auditing, updating, and deleting emojis based on naming conventions. The script fetches emoji details, categorizes them by their naming patterns, renames non-standard emojis to follow a consistent prefix convention, and removes deprecated emojis.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions for emoji management.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your Discord credentials and emoji configuration:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild ID>"
   emojiIdsToAudit = ["<Emoji ID 1>", "<Emoji ID 2>", "<Emoji ID 3>"]
   ```

   > **Note:** The `emojiIdsToAudit` array should contain the IDs of emojis you want to audit and manage. The bot token must have the `Manage Emojis and Stickers` permission in the specified guild.

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the audit results and any updates or deletions performed.

```shell
bal run
```