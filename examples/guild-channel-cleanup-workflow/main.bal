import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Minimum number of pinned messages to consider a channel as "active"
const int MIN_PINNED_MESSAGES_THRESHOLD = 1;

// Channel type constant for text channels (GUILDTEXT = 0)
const int GUILD_TEXT_CHANNEL_TYPE = 0;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Guild Channel Cleanup and Archival Workflow ===\n");

    // Step 1: Retrieve all channels in the guild to analyze channel structure
    io:println("Step 1: Fetching all channels in the guild...");
    discord:InlineResponseItems2007[] channels = check discordClient->/guilds/[guildId]/channels();
    io:println(string `Found ${channels.length()} channels in the guild.\n`);

    // Arrays to track channel categories
    string[] activeChannelIds = [];
    string[] inactiveChannelIds = [];
    string[] preservedChannelIds = [];

    // Step 2: Analyze each text channel by checking pinned messages
    io:println("Step 2: Analyzing text channels for activity (checking pinned messages)...\n");

    foreach discord:InlineResponseItems2007 channelItem in channels {
        // Extract channel information based on channel type
        string? channelId = extractChannelId(channelItem);
        string? channelName = extractChannelName(channelItem);
        int? channelType = extractChannelType(channelItem);

        if channelId is () || channelName is () || channelType is () {
            continue;
        }

        // Only process text channels (type 0 = GUILDTEXT)
        if channelType != GUILD_TEXT_CHANNEL_TYPE {
            io:println(string `Skipping non-text channel: ${channelName} (type: ${channelType})`);
            continue;
        }

        io:println(string `Analyzing text channel: ${channelName} (ID: ${channelId})`);

        // Fetch pinned messages to determine channel activity/importance
        discord:MessageResponse[]|error pinnedMessages = discordClient->/channels/[channelId]/pins();

        if pinnedMessages is error {
            io:println(string `  - Error fetching pinned messages: ${pinnedMessages.message()}`);
            io:println(string `  - Marking as inactive due to access issues.\n`);
            inactiveChannelIds.push(channelId);
            continue;
        }

        int pinnedCount = pinnedMessages.length();
        io:println(string `  - Found ${pinnedCount} pinned message(s)`);

        if pinnedCount >= MIN_PINNED_MESSAGES_THRESHOLD {
            io:println(string `  - Channel marked as ACTIVE (has important pinned content)\n`);
            activeChannelIds.push(channelId);
        } else {
            io:println(string `  - Channel marked as INACTIVE (no pinned messages)\n`);
            inactiveChannelIds.push(channelId);
        }
    }

    // Step 3: Create backup webhooks in active channels for preservation
    io:println("=== Step 3: Creating backup webhooks in active channels for archival ===\n");

    foreach string activeChannelId in activeChannelIds {
        io:println(string `Creating archival webhook for channel ID: ${activeChannelId}`);

        discord:ChannelsWebhooksRequest webhookPayload = {
            name: "Archive Bot Webhook"
        };

        discord:GuildIncomingWebhookResponse|error webhookResponse = 
            discordClient->/channels/[activeChannelId]/webhooks.post(webhookPayload);

        if webhookResponse is error {
            io:println(string `  - Failed to create webhook: ${webhookResponse.message()}\n`);
            continue;
        }

        string webhookId = webhookResponse.id;
        string? webhookName = webhookResponse?.name;

        io:println(string `  - Webhook created successfully!`);
        io:println(string `  - Webhook ID: ${webhookId}`);
        
        if webhookName is string {
            io:println(string `  - Webhook Name: ${webhookName}`);
        }
        
        string? webhookUrl = webhookResponse?.url;
        if webhookUrl is string {
            io:println(string `  - Webhook URL: ${webhookUrl}`);
        }
        io:println("");

        preservedChannelIds.push(activeChannelId);
    }

    // Summary Report
    io:println("=== Cleanup Workflow Summary ===\n");
    io:println(string `Total channels analyzed: ${activeChannelIds.length() + inactiveChannelIds.length()}`);
    io:println(string `Active channels (with pinned messages): ${activeChannelIds.length()}`);
    io:println(string `Inactive channels (candidates for cleanup): ${inactiveChannelIds.length()}`);
    io:println(string `Channels with backup webhooks created: ${preservedChannelIds.length()}`);

    io:println("\n--- Active Channel IDs (preserved with webhooks) ---");
    foreach string id in preservedChannelIds {
        io:println(string `  - ${id}`);
    }

    io:println("\n--- Inactive Channel IDs (ready for cleanup) ---");
    foreach string id in inactiveChannelIds {
        io:println(string `  - ${id}`);
    }

    io:println("\n=== Workflow completed successfully! ===");
    io:println("Note: Actual channel deletion should be performed manually or with additional confirmation.");
}

// Helper function to extract channel ID from the union type
function extractChannelId(discord:InlineResponseItems2007 channelItem) returns string? {
    if channelItem is discord:GuildChannelResponse {
        return channelItem.id;
    } else if channelItem is discord:PrivateChannelResponse {
        return channelItem.id;
    } else if channelItem is discord:PrivateGroupChannelResponse {
        return channelItem.id;
    } else if channelItem is discord:ThreadResponse {
        return channelItem.id;
    }
    return ();
}

// Helper function to extract channel name from the union type
function extractChannelName(discord:InlineResponseItems2007 channelItem) returns string? {
    if channelItem is discord:GuildChannelResponse {
        string? nameValue = channelItem?.name;
        return nameValue;
    } else if channelItem is discord:PrivateChannelResponse {
        return "Private Channel";
    } else if channelItem is discord:PrivateGroupChannelResponse {
        string? nameValue = channelItem?.name;
        return nameValue;
    } else if channelItem is discord:ThreadResponse {
        return channelItem.name;
    }
    return ();
}

// Helper function to extract channel type from the union type
function extractChannelType(discord:InlineResponseItems2007 channelItem) returns int? {
    if channelItem is discord:GuildChannelResponse {
        return channelItem.'type;
    } else if channelItem is discord:PrivateChannelResponse {
        return channelItem.'type;
    } else if channelItem is discord:PrivateGroupChannelResponse {
        return channelItem.'type;
    } else if channelItem is discord:ThreadResponse {
        return channelItem.'type;
    }
    return ();
}