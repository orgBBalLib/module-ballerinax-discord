# Channel Announcement Pinning

This example demonstrates how to automate Discord channel announcement management by verifying channel access through archived threads retrieval and pinning important messages for community visibility.

## Prerequisites

1. **Discord Setup**
   > Refer to the [Discord setup guide](https://central.ballerina.io/ballerinax/discord/latest) to create a bot application and obtain your bot token with the necessary permissions (Manage Messages).

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your Discord credentials:

   ```toml
   botToken = "<Your Discord Bot Token>"
   channelId = "<Your Discord Channel ID>"
   ```

## Run the Example

Execute the following command to run the example. The script will verify channel access, and pin the specified announcement message.

```shell
bal run
```