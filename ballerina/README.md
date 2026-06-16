## Overview

[Discord](https://discord.com/) is a communication platform that enables communities and teams to connect through text, voice, and video channels, providing a space for real-time collaboration and engagement.

The `ballerinax/discord` package offers APIs to connect and interact with [Discord API](https://discord.com/developers/docs/intro) endpoints, specifically based on [Discord API v10](https://discord.com/developers/docs/reference#api-versioning).
## Setup guide

To use the Discord connector, you must have access to the Discord API through a [Discord Developer Portal](https://discord.com/developers/docs/intro) account and obtain a Bot Token. If you do not have a Discord account, you can sign up for one [here](https://discord.com/register).

### Step 1: Create a Discord Account

1. Navigate to the [Discord website](https://discord.com/) and sign up for an account or log in if you already have one.

2. Discord API access is available to all users at no cost. There are no subscription plan requirements to create applications and obtain API credentials.

### Step 2: Generate a Bot Token

1. Log in to your Discord account and navigate to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Click the **New Application** button in the top right corner.

3. Enter a name for your application and click **Create**.

4. In the left sidebar, navigate to the **Bot** section.

5. Click the **Add Bot** button and confirm by clicking **Yes, do it!**.

6. Under the **Token** section, click **Reset Token** (or **Copy** if visible) to generate and copy your bot token.

7. Configure the necessary **Privileged Gateway Intents** (such as Presence Intent, Server Members Intent, or Message Content Intent) based on your application's requirements.

> **Tip:** You must copy and store this token somewhere safe. It won't be visible again in the Developer Portal for security reasons. If you lose it, you will need to regenerate a new token.
## Quickstart

To use the `discord` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/discord;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained bot token:

```toml
token = "<Your_Discord_Bot_Token>"
```

2. Create a `discord:ConnectionConfig` and initialize the client:

```ballerina
configurable string token = ?;

final discord:Client discordClient = check new ({
    auth: {
        token
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new guild

```ballerina
public function main() returns error? {
    discord:GuildCreateRequest newGuild = {
        name: "My Awesome Server"
    };

    discord:GuildResponse response = check discordClient->/guilds.post(newGuild);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `Discord` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples), covering the following use cases:

1. [Guild moderation report](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-moderation-report) - Demonstrates how to generate moderation reports for a Discord guild using the Ballerina connector.
2. [Guild channel organization](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-organization) - Illustrates organizing and managing channels within a Discord guild.
3. [Server onboarding automation](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/server-onboarding-automation) - Shows how to automate the onboarding process for new members joining a Discord server.
4. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Demonstrates creating, updating, and managing roles within a Discord guild.