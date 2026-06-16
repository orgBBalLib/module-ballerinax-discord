# Guild Onboarding Configuration

This example demonstrates how to configure and customize Discord guild onboarding using the Ballerina Discord connector. The script fetches the current onboarding configuration, prepares a customized onboarding flow with welcome prompts and interest-based role selection, and updates the guild's onboarding settings.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest#setup-guide) to obtain your bot token and configure the necessary permissions.

2. **Guild and Channel Configuration**
   > You will need the following IDs from your Discord server:
   > - Guild (Server) ID
   > - Channel IDs for welcome, rules, and general channels
   > - Role IDs for member, gaming, and art roles

3. For this example, create a `Config.toml` file with your credentials:

```toml
botToken = "<Your Bot Token>"
guildId = "<Your Guild ID>"
welcomeChannelId = "<Your Welcome Channel ID>"
rulesChannelId = "<Your Rules Channel ID>"
generalChannelId = "<Your General Channel ID>"
memberRoleId = "<Your Member Role ID>"
gamingRoleId = "<Your Gaming Role ID>"
artRoleId = "<Your Art Role ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the current onboarding configuration, the update process, and the final configured prompts.

```shell
bal run
```