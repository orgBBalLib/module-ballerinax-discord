
# Ballerina discord connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-discord/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-discord.svg)](https://github.com/ballerina-platform/module-ballerinax-discord/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/discord.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%discord)

## Overview

[Discord](https://discord.com/) is a communication platform that enables communities to connect through voice, video, and text chat, providing a space for people to create servers, organize conversations, and build engaged communities around shared interests.

The `ballerinax/discord` package offers APIs to connect and interact with [Discord API](https://discord.com/developers/docs/intro) endpoints, specifically based on [Discord API v10](https://discord.com/developers/docs/reference#api-versioning).
## Setup guide

To use the Discord connector, you must have access to the Discord API through a [Discord Developer Portal](https://discord.com/developers/docs/intro) account and obtain a Bot Token. If you do not have a Discord account, you can sign up for one [here](https://discord.com/register).

### Step 1: Create a Discord Account

1. Navigate to the [Discord website](https://discord.com/) and sign up for an account or log in if you already have one.

2. The Discord API is available to all Discord users at no additional cost—there are no subscription plan restrictions for API access.

### Step 2: Generate a Bot Token

1. Log in to the [Discord Developer Portal](https://discord.com/developers/applications).

2. Click the "New Application" button in the top right corner, enter a name for your application, and click "Create".

3. In the left sidebar of your application page, navigate to the "Bot" section.

4. Click the "Add Bot" button and confirm by clicking "Yes, do it!" in the popup.

5. Under the "Token" section, click "Reset Token" (or "Copy" if visible) to generate and reveal your bot token.

6. Click "Copy" to copy the token to your clipboard.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons.
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
2. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Illustrates creating, updating, and managing roles within a Discord guild.
3. [Guild event reminder workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-event-reminder-workflow) - Shows how to set up automated event reminders for scheduled guild events.
4. [Guild channel cleanup workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-cleanup-workflow) - Demonstrates automating the cleanup and management of channels in a Discord guild.
## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

    > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

    > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

    ```bash
    ./gradlew clean build
    ```

2. To run the tests:

    ```bash
    ./gradlew clean test
    ```

3. To build the without the tests:

    ```bash
    ./gradlew clean build -x test
    ```

4. To run tests against different environments:

    ```bash
    ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
    ```

5. To debug the package with a remote debugger:

    ```bash
    ./gradlew clean build -Pdebug=<port>
    ```

6. To debug with the Ballerina language:

    ```bash
    ./gradlew clean build -PbalJavaDebug=<port>
    ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToCentral=true
    ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).


## Useful links

* For more information go to the [`discord` package](https://central.ballerina.io/ballerinax/discord/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
