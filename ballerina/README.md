## Overview

[Discord](https://discord.com/) is a communication platform that provides voice, video, and text chat capabilities, enabling communities, gaming groups, and teams to connect and collaborate in organized servers with customizable channels and roles.

The `ballerinax/discord` package offers APIs to connect and interact with [Discord API](https://discord.com/developers/docs/intro) endpoints, specifically based on [Discord API v10](https://discord.com/developers/docs/reference#api-versioning).
## Setup guide

To use the Discord connector, you must have access to the Discord API through a [Discord Developer Portal](https://discord.com/developers/docs/intro) account and obtain a Bot Token. If you do not have a Discord account, you can sign up for one [here](https://discord.com/register).

### Step 1: Create a Discord Account

1. Navigate to the [Discord website](https://discord.com/) and sign up for an account or log in if you already have one.

2. The Discord API is available to all users at no cost. There are no subscription plan requirements to access the API, though rate limits apply based on your application's usage.

### Step 2: Generate a Bot Token

1. Log in to your Discord account and navigate to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Click the **New Application** button in the top-right corner, enter a name for your application, and click **Create**.

3. In the left sidebar of your application page, select **Bot**.

4. Click the **Reset Token** button (or **Add Bot** if creating for the first time) to generate your bot token.

5. Click **Copy** to copy your bot token to your clipboard.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons. If you lose it, you will need to regenerate a new token.
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

final discord:Client discordClient = check new({
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

1. [Guild onboarding configuration](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-onboarding-configuration) - Demonstrates how to configure and manage onboarding settings for a Discord guild.
2. [Guild event RSVP tracking](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-event-rsvp-tracking) - Illustrates tracking and managing user RSVPs for scheduled guild events.
3. [Channel announcement pinning](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/channel-announcement-pinning) - Shows how to pin important announcements in Discord channels.
4. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Demonstrates creating, updating, and managing roles within a Discord guild.