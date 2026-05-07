# Guild Event RSVP Tracking

This example demonstrates how to automate Discord guild scheduled event management by listing all scheduled events, identifying upcoming events within the next 24 hours, and fetching RSVP attendee lists to generate a summary report for community managers.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. **Obtain Guild ID**
   > Enable Developer Mode in Discord (User Settings > App Settings > Advanced > Developer Mode), then right-click on your server and select "Copy Server ID" to get your Guild ID.

3. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
```

## Run the Example

Execute the following command to run the example. The script will fetch scheduled events, filter those occurring within 24 hours, retrieve RSVP lists, and print a detailed summary report to the console.

```shell
bal run
```