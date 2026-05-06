## Overview

[Discord](https://discord.com/) is a popular communication platform that provides voice, video, and text chat capabilities, enabling communities, gamers, and teams to connect and collaborate in real-time through organized servers and channels.

The `ballerinax/discord` package offers APIs to connect and interact with [Discord API](https://discord.com/developers/docs/intro) endpoints, specifically based on [Discord API v10](https://discord.com/developers/docs/reference#api-versioning).
## Setup guide

To use the Discord connector, you must have access to the Discord API through a [Discord Developer Portal](https://discord.com/developers/docs/intro) account and obtain a Bot Token. If you do not have a Discord account, you can sign up for one [here](https://discord.com/register).

### Step 1: Create a Discord Account

1. Navigate to the [Discord website](https://discord.com/) and sign up for an account or log in if you already have one.

2. The Discord API is available to all users at no cost. There are no subscription plan requirements to access the API, though rate limits apply based on your usage.

### Step 2: Generate a Bot Token

1. Log in to your Discord account and navigate to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Click the **New Application** button in the top right corner, enter a name for your application, and click **Create**.

3. In the left sidebar of your application page, select **Bot**.

4. Click the **Reset Token** button (or **Add Bot** if creating for the first time) to generate your bot token.

5. Click **Copy** to copy your bot token to your clipboard.

6. Configure the necessary **Privileged Gateway Intents** (such as Presence Intent, Server Members Intent, or Message Content Intent) based on your application's requirements.

> **Tip:** You must copy and store this token somewhere safe. It won't be visible again in the Developer Portal for security reasons, and you will need to regenerate it if lost.
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
        authorization: token
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new guild

```ballerina
public function main() returns error? {
    discord:GuildCreateRequest newGuild = {
        name: "My Ballerina Server"
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

1. [Guild onboarding configuration](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-onboarding-configuration) - Demonstrates how to configure onboarding settings for a Discord guild.
2. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Illustrates creating, updating, and managing roles within a Discord guild.
3. [Guild event reminder workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-event-reminder-workflow) - Shows how to automate event reminders for scheduled guild events.
4. [Guild channel cleanup workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-cleanup-workflow) - Demonstrates automating the cleanup of unused or inactive channels in a guild.