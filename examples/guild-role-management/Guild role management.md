# Guild Role Management

This example demonstrates how to automate Discord guild (server) role management using the Ballerina Discord connector. The script retrieves existing roles, creates a new moderation team role with specific permissions, assigns it to a target user, and verifies the role creation.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a Discord bot application and obtain your bot token with appropriate permissions.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with the following configuration:

   ```toml
   discordBotToken = "<Your Discord Bot Token>"
   guildId = "<Your Guild/Server ID>"
   targetUserId = "<Target User ID to Assign Role>"
   ```

   > **Note:** Ensure your bot has the `MANAGE_ROLES` permission in the target guild and is positioned higher in the role hierarchy than the roles it needs to manage.

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing each step of the role management process.

```shell
bal run
```