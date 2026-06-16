import ballerina/io;
import ballerinax/discord;

configurable string discordBotToken = ?;
configurable string guildId = ?;

public function main() returns error? {
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Guild Channel Management Automation ===\n");

    io:println("Step 1: Retrieving all channels in the guild...");
    discord:InlineResponseItems2007[] channels = check discordClient->/guilds/[guildId]/channels();
    
    io:println("Found ", channels.length(), " channels in the guild:");
    foreach discord:InlineResponseItems2007 channel in channels {
        if channel is discord:GuildChannelResponse {
            string channelName = channel.name is string ? channel.name : "Unnamed";
            io:println("  - Channel: ", channelName, " (ID: ", channel.id, ", Type: ", channel.'type, ")");
        }
    }
    io:println();

    io:println("Step 2: Creating a new announcement channel...");
    
    discord:CreateGuildChannelRequest newChannelRequest = {
        name: "important-announcements",
        'type: 5,
        topic: "Official announcements and important updates for the community",
        nsfw: false
    };

    discord:GuildChannelResponse createdChannel = check discordClient->/guilds/[guildId]/channels.post(newChannelRequest);
    
    string createdChannelName = createdChannel.name is string ? createdChannel.name : "Unnamed";
    io:println("Successfully created announcement channel:");
    io:println("  - Name: ", createdChannelName);
    io:println("  - ID: ", createdChannel.id);
    io:println("  - Type: ", createdChannel.'type);
    io:println();

    io:println("Step 3: Setting up a webhook for external service notifications...");
    
    string channelId = createdChannel.id;
    
    discord:ChannelsWebhooksRequest webhookRequest = {
        name: "External Notifications Bot",
        avatar: ()
    };

    discord:GuildIncomingWebhookResponse webhook = check discordClient->/channels/[channelId]/webhooks.post(webhookRequest);
    
    string? webhookNameOptional = webhook?.name;
    string webhookName = webhookNameOptional is string ? webhookNameOptional : "Unknown";
    string? webhookUrlOptional = webhook?.url;
    string webhookUrl = webhookUrlOptional is string ? webhookUrlOptional : "Not available";
    string? webhookTokenOptional = webhook?.token;
    string webhookToken = webhookTokenOptional is string ? webhookTokenOptional : "Not available";
    
    io:println("Successfully created webhook:");
    io:println("  - Name: ", webhookName);
    io:println("  - ID: ", webhook.id);
    io:println("  - Webhook URL: ", webhookUrl);
    io:println("  - Token: ", webhookToken);
    io:println();

    string summaryChannelName = createdChannel.name is string ? createdChannel.name : "important-announcements";
    
    io:println("=== Automation Complete ===");
    io:println("Summary:");
    io:println("  1. Retrieved ", channels.length(), " existing channels from the guild");
    io:println("  2. Created new announcement channel: ", summaryChannelName);
    io:println("  3. Set up webhook '", webhookName, "' for external service integration");
    io:println();
    io:println("External services can now post notifications to the announcement channel");
    io:println("using the webhook URL provided above.");
}