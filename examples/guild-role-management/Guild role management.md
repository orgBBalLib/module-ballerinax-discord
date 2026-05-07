# Guild Role Management

This example demonstrates how to automate Discord guild role management by retrieving existing roles, creating a new custom role with specific permissions for bot integration, and assigning the newly created role to a specific guild member.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. **Obtain Guild and User IDs**
   - Enable Developer Mode in Discord (User Settings → App Settings → Advanced → Developer Mode)
   - Right-click on your server to copy the Guild ID
   - Right-click on the target user to copy their User ID

3. For this example, create a `Config.toml` file with your credentials:

```toml
botToken = "<Your Bot Token>"
guildId = "<Your Guild ID>"
targetUserId = "<Target User ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Role Management System ===

Step 1: Fetching all existing roles from the guild...
Found 5 existing roles in the guild:
  - Role: @everyone (ID: 123456789, Position: 0)
  - Role: Admin (ID: 987654321, Position: 4)
  ...

Step 2: Creating a new custom role for bot integration...
Successfully created new role:
  - Name: Bot Integration Role
  - ID: 1122334455
  - Color: 3447003
  - Hoisted: true
  - Mentionable: false
  - Position: 1

Step 3: Assigning the new role to member with ID: 555666777...
Successfully assigned role 'Bot Integration Role' to member!

Step 4: Verifying role creation by fetching updated role list...
Verification successful! Role 'Bot Integration Role' exists in the guild.

=== Guild Role Management Complete ===
Summary:
  - Retrieved 5 existing roles
  - Created new role: Bot Integration Role (ID: 1122334455)
  - Assigned role to user: 555666777
```