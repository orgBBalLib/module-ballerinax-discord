## Overview

[Discord](https://discord.com/) is a communication platform that brings communities together through text, voice, and video, enabling real-time conversations and collaboration for gaming, education, business, and social groups worldwide.

The `ballerinax/discord` package offers APIs to connect and interact with [Discord API](https://discord.com/developers/docs/intro) endpoints, specifically based on [Discord API v10](https://discord.com/developers/docs/reference#api-versioning).
## Setup guide

To use the Discord connector, you must have access to the Discord API through a [Discord Developer Portal](https://discord.com/developers/docs/intro) account and obtain a Bot Token. If you do not have a Discord account, you can sign up for one [here](https://discord.com/register).

### Step 1: Create a Discord Account

1. Navigate to the [Discord website](https://discord.com/) and sign up for an account or log in if you already have one.

2. The Discord API is available to all Discord users at no cost. There are no premium subscription plans required to access the API for bot development.

### Step 2: Generate a Bot Token

1. Log in to your Discord account and navigate to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Click the "New Application" button in the top right corner, enter a name for your application, and click "Create".

3. In the left sidebar of your application page, select "Bot".

4. Click the "Add Bot" button and confirm by clicking "Yes, do it!".

5. Under the "Token" section, click "Reset Token" (or "Copy" if generating for the first time) to reveal and copy your bot token.

6. Configure the necessary bot permissions and privileged gateway intents based on your application requirements.

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

1. [Discord event scheduling](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/discord-event-scheduling) - Demonstrates how to create and manage scheduled events in a Discord server.
2. [Guild emoji management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-emoji-management) - Illustrates adding, updating, and removing custom emojis in a guild.
3. [Guild channel webhook setup](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-webhook-setup) - Shows how to create and configure webhooks for guild channels.
4. [Inactive member prune workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/inactive-member-prune-workflow) - Demonstrates how to identify and remove inactive members from a guild.