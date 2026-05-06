# Inactive Member Prune Workflow

This example demonstrates how to automate Discord server maintenance by identifying and removing inactive members. The workflow searches for guild members, previews the prune operation to estimate inactive users, and then executes the prune for members who have been inactive for 7 or more days.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a bot application and obtain your bot token. Ensure your bot has the `KICK_MEMBERS` permission in the target guild.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your Discord credentials:

   ```toml
   botToken = "<Your Bot Token>"
   guildId = "<Your Guild ID>"
   ```

   - `botToken`: Your Discord bot's authentication token
   - `guildId`: The ID of the Discord server (guild) where you want to prune inactive members

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing member analysis results and prune operation status.

```shell
bal run
```