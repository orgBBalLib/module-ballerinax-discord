import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Guild Channel Organization and Announcement System ===\n");

    // Step 1: Fetch all existing channels in the guild
    io:println("Step 1: Fetching all existing channels in the guild...");
    discord:InlineResponseItems2007[] channels = check discordClient->/guilds/[guildId]/channels();
    
    io:println("Found ", channels.length(), " channels in the guild:");
    foreach discord:InlineResponseItems2007 channel in channels {
        // Handle the union type by checking for GuildChannelResponse
        if channel is discord:GuildChannelResponse {
            string channelName = channel.name is string ? channel.name : "Unknown";
            io:println("  - Channel: ", channelName, " (ID: ", channel.id, ", Type: ", channel.'type, ")");
        } else if channel is discord:ThreadResponse {
            string threadName = channel.name is string ? channel.name : "Unknown";
            io:println("  - Thread: ", threadName, " (ID: ", channel.id, ")");
        } else if channel is () {
            io:println("  - Unknown channel type");
        }
    }
    io:println();

    // Step 2: Create a new announcements channel with proper configuration
    io:println("Step 2: Creating a new announcements channel...");
    
    // Prepare the channel creation request
    // Type 5 represents GUILDANNOUNCEMENT channel type
    discord:CreateGuildChannelRequest createChannelRequest = {
        name: "server-announcements",
        'type: 5,
        topic: "Official server announcements and updates. Stay informed about server changes!",
        nsfw: false,
        rateLimitPerUser: 0
    };

    discord:GuildChannelResponse newChannel = check discordClient->/guilds/[guildId]/channels.post(createChannelRequest);
    
    string newChannelName = newChannel.name is string ? newChannel.name : "Unknown";
    string? topicValue = newChannel?.topic;
    string newChannelTopic = topicValue is string ? topicValue : "No topic set";
    
    io:println("Successfully created announcements channel!");
    io:println("  - Channel Name: ", newChannelName);
    io:println("  - Channel ID: ", newChannel.id);
    io:println("  - Channel Type: ", newChannel.'type);
    io:println("  - Topic: ", newChannelTopic);
    io:println();

    // Step 3: Display summary of the channel organization
    io:println("Step 3: Channel Organization Summary");
    io:println("=====================================");
    io:println("Total channels before: ", channels.length());
    io:println("New channel created: server-announcements (ID: ", newChannel.id, ")");
    io:println("Total channels after: ", channels.length() + 1);
    io:println();

    // Provide guidance for posting messages
    io:println("=== Next Steps ===");
    io:println("The announcements channel has been created successfully.");
    io:println("Channel ID for posting messages: ", newChannel.id);
    io:println();
    io:println("To post a welcome message, use the Discord messages API with the channel ID above.");
    io:println("Example message content: 'Welcome to our reorganized server! This channel will be used for all official announcements.'");
    io:println();

    // Display final channel list
    io:println("=== Updated Channel List ===");
    discord:InlineResponseItems2007[] updatedChannels = check discordClient->/guilds/[guildId]/channels();
    
    int textChannelCount = 0;
    int voiceChannelCount = 0;
    int categoryCount = 0;
    int announcementCount = 0;
    int otherCount = 0;

    foreach discord:InlineResponseItems2007 channel in updatedChannels {
        if channel is discord:GuildChannelResponse {
            match channel.'type {
                0 => {
                    textChannelCount += 1;
                }
                2 => {
                    voiceChannelCount += 1;
                }
                4 => {
                    categoryCount += 1;
                }
                5 => {
                    announcementCount += 1;
                }
                _ => {
                    otherCount += 1;
                }
            }
        }
    }

    io:println("Channel Statistics:");
    io:println("  - Text Channels: ", textChannelCount);
    io:println("  - Voice Channels: ", voiceChannelCount);
    io:println("  - Categories: ", categoryCount);
    io:println("  - Announcement Channels: ", announcementCount);
    io:println("  - Other Channels: ", otherCount);
    io:println("  - Total: ", updatedChannels.length());
    io:println();

    io:println("=== Guild Channel Organization Complete ===");
}