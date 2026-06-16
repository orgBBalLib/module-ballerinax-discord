# Guild Onboarding Setup

This example demonstrates how to configure Discord guild onboarding settings using the Ballerina Discord connector. The script retrieves the current onboarding configuration, then updates it with custom prompts for member interests and notification preferences, along with default channels for new members.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a Discord bot and obtain the bot token with appropriate permissions.

2. **Guild Configuration**
   > Ensure your Discord bot has the `MANAGE_GUILD` permission and that Community features are enabled on your server to use onboarding functionality.

3. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
welcomeChannelId = "<Your Welcome Channel ID>"
rulesChannelId = "<Your Rules Channel ID>"
generalChannelId = "<Your General Channel ID>"
introductionsChannelId = "<Your Introductions Channel ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the current onboarding configuration and the updated settings.

```shell
bal run
```