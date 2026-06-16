# Guild Channel Cleanup Workflow

This example demonstrates how to automate Discord guild channel analysis and archival preparation using the Ballerina Discord connector. The script retrieves all channels in a guild, analyzes text channels for activity by checking pinned messages, creates backup webhooks in active channels, and generates a summary report identifying inactive channels ready for cleanup.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a Discord bot and obtain your bot token. Ensure the bot has permissions to view channels, read message history, and manage webhooks in your target guild.

2. **Obtain Guild ID**
   > Enable Developer Mode in Discord (User Settings → Advanced → Developer Mode), then right-click on your server and select "Copy Server ID" to get the guild ID.

3. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
```

## Run the Example

Execute the following command to run the example. The script will analyze all channels in the specified guild, identify active and inactive channels based on pinned messages, create archival webhooks for active channels, and print a detailed summary report to the console.

```shell
bal run
```

The output will display:
- A list of all channels being analyzed
- Activity status for each text channel based on pinned message count
- Webhook creation results for active channels
- A final summary showing active channels (preserved with webhooks) and inactive channels (candidates for cleanup)