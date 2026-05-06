# Examples

The `discord` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples), covering use cases like guild onboarding configuration, guild role management, guild event reminder workflow, and guild channel cleanup workflow.

1. [Guild onboarding configuration](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-onboarding-configuration) - Configure the onboarding process for new members joining a Discord guild.

2. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Manage and automate role assignments within a Discord guild.

3. [Guild event reminder workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-event-reminder-workflow) - Set up automated reminders for scheduled events in a Discord guild.

4. [Guild channel cleanup workflow](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-cleanup-workflow) - Automate the cleanup and management of channels within a Discord guild.

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