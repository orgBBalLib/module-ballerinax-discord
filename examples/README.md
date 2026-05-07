# Examples

The `discord` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples), covering use cases like guild onboarding configuration, guild event RSVP tracking, channel announcement pinning, and guild role management.

1. [Guild onboarding configuration](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-onboarding-configuration) - Configure and manage the onboarding process for new members joining a Discord guild.

2. [Guild event RSVP tracking](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-event-rsvp-tracking) - Track and manage RSVP responses for scheduled events within a Discord guild.

3. [Channel announcement pinning](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/channel-announcement-pinning) - Automatically pin important announcements to Discord channels for easy visibility.

4. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Manage and assign roles to members within a Discord guild programmatically.

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