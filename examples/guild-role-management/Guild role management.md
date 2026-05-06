# Guild Role Management

This example demonstrates how to manage Discord guild roles programmatically using the Ballerina Discord connector. The script retrieves existing roles, creates a new custom role for event participants, assigns it to a specified user, and verifies the changes.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a bot application and obtain your bot token.

2. **Guild and User Information**
   - You need the Guild ID (Server ID) where you want to manage roles
   - You need the User ID of the member to assign the role to
   - Your bot must have the `MANAGE_ROLES` permission in the guild

3. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
guildId = "<Your Guild ID>"
targetUserId = "<Target User ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console as it performs each step of the role management workflow.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Discord Guild Role Management System ===

Step 1: Fetching all roles in the guild...
Found 5 roles in the guild:
  - @everyone (ID: 123456789, Position: 0)
  - Moderator (ID: 234567890, Position: 2)
  ...

Step 2: Creating a new custom role for event participants...
Successfully created new role:
  - Name: Event Participant
  - ID: 345678901
  - Color: 3447003
  - Hoisted: true
  - Mentionable: true

Step 3: Assigning the new role to the target user...
Successfully assigned role 'Event Participant' to user ID: 456789012

Step 4: Verifying role creation by fetching updated roles list...
Updated roles list (6 roles):
  - Event Participant (ID: 345678901) [NEW]
  ...

=== Role Management Workflow Completed Successfully ===
```