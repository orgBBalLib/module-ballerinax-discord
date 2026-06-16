# Guild Event Announcements

This example demonstrates an automated Discord guild event management system workflow that retrieves private archived threads from an announcement channel and prepares bulk message cleanup operations for old event announcements.

## Prerequisites

1. **Discord Setup**
   > Refer the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to obtain your bot token and configure the necessary permissions.

2. For this example, create a `Config.toml` file with your credentials:

```toml
discordBotToken = "<Your Discord Bot Token>"
announcementChannelId = "<Your Announcement Channel ID>"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing archived thread information and preparing a bulk delete operation in dry-run mode.

```shell
bal run
```