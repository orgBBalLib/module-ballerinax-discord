# Server Onboarding Automation

This example demonstrates how to automate Discord server onboarding configuration using the Ballerina Discord connector. The script retrieves the current onboarding setup for a guild, creates customized onboarding prompts (interests and notification preferences), and updates the server's onboarding flow for new members.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a bot application and obtain your bot token with appropriate permissions.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your Discord credentials and channel IDs:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild/Server ID>"
   welcomeChannelId = "<Your Welcome Channel ID>"
   rulesChannelId = "<Your Rules Channel ID>"
   generalChannelId = "<Your General Channel ID>"
   ```

   > **Note:** Ensure your bot has the `MANAGE_GUILD` permission to modify onboarding settings.

## Run the Example

Execute the following command to run the example. The script will print its progress to the console as it fetches the current onboarding configuration, prepares the updates, and applies them to your Discord server.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Server Onboarding System ===

Step 1: Fetching current onboarding configuration...
Current Onboarding Status:
  - Guild ID: 123456789012345678
  - Onboarding Enabled: true
  - Number of Prompts: 0
  - Default Channels: 0

Step 2: Preparing updated onboarding configuration...
...

=== Onboarding Update Successful! ===
...

=== Onboarding System Configuration Complete ===
New members will now see the updated onboarding flow when joining your server!
```