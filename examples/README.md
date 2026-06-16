# Examples

The `discord` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples), covering use cases like guild moderation reporting, channel organization, server onboarding automation, and role management.

1. [Guild moderation report](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-moderation-report) - Generate comprehensive moderation reports for a Discord guild including audit logs and member activities.

2. [Guild channel organization](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-channel-organization) - Organize and manage channels within a Discord guild by creating, updating, and categorizing them.

3. [Server onboarding automation](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/server-onboarding-automation) - Automate the onboarding process for new members joining a Discord server with welcome messages and role assignments.

4. [Guild role management](https://github.com/ballerina-platform/module-ballerinax-discord/tree/main/examples/guild-role-management) - Manage roles within a Discord guild by creating, updating, and assigning roles to members.

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