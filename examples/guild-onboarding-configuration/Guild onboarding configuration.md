# Guild Onboarding Configuration

This example demonstrates how to configure Discord guild onboarding using the Ballerina Discord connector. The script retrieves current onboarding settings, creates customized welcome prompts with role and channel selections, and applies the updated onboarding configuration to enhance the new member experience.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a bot application and obtain your bot token. Ensure your bot has the `MANAGE_GUILD` permission and is added to your target server.

2. **Gather Guild Resources**
   > You'll need the following IDs from your Discord server:
   > - Guild (Server) ID
   > - Channel IDs for welcome, rules, and general channels
   > - Role IDs for member, gamer, and developer roles
   >
   > You can obtain these by enabling Developer Mode in Discord settings and right-clicking on the respective channels/roles.

3. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your credentials:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild ID>"
   welcomeChannelId = "<Your Welcome Channel ID>"
   rulesChannelId = "<Your Rules Channel ID>"
   generalChannelId = "<Your General Channel ID>"
   memberRoleId = "<Your Member Role ID>"
   gamerRoleId = "<Your Gamer Role ID>"
   developerRoleId = "<Your Developer Role ID>"
   ```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the current onboarding configuration, the update process, and the final configured prompts.

```shell
bal run
```