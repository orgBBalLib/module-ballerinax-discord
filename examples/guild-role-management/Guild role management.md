# Guild Role Management

This example demonstrates how to automate guild role management in Discord, including retrieving existing roles, creating new custom roles, updating role properties, and verifying the final role hierarchy.

## Prerequisites

1. **Discord Setup**
   > Refer the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing each step of the role management process.

```shell
bal run
```

Upon successful execution, you will see output showing:
- All existing roles in the guild
- Creation of a new "Project Alpha Team" role
- Update of the role to "Project Alpha Team - Lead" with enhanced permissions
- Final verification of the complete role hierarchy