# Examples

The `discord` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples), covering use cases like Discord event scheduling, guild emoji management, guild channel webhook setup, and inactive member prune workflow.

1. [Discord event scheduling](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/discord-event-scheduling) - Schedule and manage events within a Discord server programmatically.

2. [Guild emoji management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-emoji-management) - Create, update, and manage custom emojis for a Discord guild.

3. [Guild channel webhook setup](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-webhook-setup) - Configure webhooks for Discord guild channels to enable automated messaging.

4. [Inactive member prune workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/inactive-member-prune-workflow) - Identify and remove inactive members from a Discord guild based on activity criteria.

## Prerequisites

1. Generate Discord credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/discord/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<Access Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```