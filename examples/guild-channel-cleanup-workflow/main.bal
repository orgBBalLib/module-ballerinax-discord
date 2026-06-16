import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string botToken = ?;

// Guild ID to manage channels for
configurable string guildId = ?;

// Channel ID to analyze for message reactions (used for activity detection)
configurable string targetChannelId = ?;

// Message ID to check reactions on (for activity analysis)
configurable string targetMessageId = ?;

// Emoji name to check for reactions (e.g., "👍" or custom emoji name)
configurable string emojiName = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: botToken
        }
    });

    io:println("=== Discord Guild Channel Cleanup and Archival Workflow ===\n");

    // Step 1: List all channels in the guild to identify target channels
    io:println("Step 1: Retrieving all channels in the guild...");
    
    discord:InlineResponseItems2007[] channels = check discordClient->/guilds/[guildId]/channels();
    
    io:println("Found ", channels.length(), " channels in the guild.\n");
    
    // Process and display channel information for analysis
    io:println("Channel Analysis Report:");
    io:println("------------------------");
    
    int textChannelCount = 0;
    int voiceChannelCount = 0;
    int categoryCount = 0;
    int threadCount = 0;
    int otherCount = 0;
    
    foreach discord:InlineResponseItems2007 channelResponse in channels {
        // Handle different channel types from the union type
        if channelResponse is discord:GuildChannelResponse {
            string? channelNameOptional = channelResponse?.name;
            string channelName = channelNameOptional ?: "Unknown";
            string channelId = channelResponse.id;
            int channelType = channelResponse.'type;
            
            string typeLabel = getChannelTypeLabel(channelType);
            io:println(string `  - [${typeLabel}] ${channelName} (ID: ${channelId})`);
            
            // Count channel types for summary
            match channelType {
                0 => { textChannelCount += 1; }
                2 => { voiceChannelCount += 1; }
                4 => { categoryCount += 1; }
                _ => { otherCount += 1; }
            }
            
            // Check for potential inactive channels based on flags or other indicators
            boolean? nsfwValue = channelResponse?.nsfw;
            if nsfwValue == true {
                io:println("      ⚠ NSFW channel - requires special handling");
            }
        } else if channelResponse is discord:ThreadResponse {
            threadCount += 1;
            io:println("  - [Thread] (Thread channel detected)");
        } else if channelResponse is discord:PrivateChannelResponse {
            io:println("  - [Private] Private channel detected");
        } else if channelResponse is discord:PrivateGroupChannelResponse {
            io:println("  - [Group] Private group channel detected");
        }
    }
    
    io:println("\nChannel Summary:");
    io:println(string `  Text Channels: ${textChannelCount}`);
    io:println(string `  Voice Channels: ${voiceChannelCount}`);
    io:println(string `  Categories: ${categoryCount}`);
    io:println(string `  Threads: ${threadCount}`);
    io:println(string `  Other: ${otherCount}`);
    
    // Step 2: Analyze activity by checking reactions on messages
    // This helps identify active vs inactive channels based on user engagement
    io:println("\n------------------------");
    io:println("Step 2: Analyzing channel activity via message reactions...");
    io:println(string `Checking reactions on message ${targetMessageId} in channel ${targetChannelId}...`);
    
    // Query parameters for pagination
    discord:ListMessageReactionsByEmojiQueries reactionQueries = {
        'limit: 100
    };
    
    discord:UserResponse[] reactedUsers = check discordClient->/channels/[targetChannelId]/messages/[targetMessageId]/reactions/[emojiName](queries = reactionQueries);
    
    io:println(string `Found ${reactedUsers.length()} users who reacted with ${emojiName}\n`);
    
    if reactedUsers.length() > 0 {
        io:println("Users who reacted (indicating activity):");
        foreach discord:UserResponse user in reactedUsers {
            string username = user.username;
            string? globalNameOptional = user?.globalName;
            string globalName = globalNameOptional ?: "No display name";
            string usedId = user.id;
            boolean? botOptional = user?.bot;
            boolean isBot = botOptional ?: false;
            
            string botIndicator = isBot ? " [BOT]" : "";
            io:println(string `  - ${globalName} (@${username})${botIndicator} - ID: ${usedId}`);
        }
        
        // Activity assessment
        int humanReactions = 0;
        foreach discord:UserResponse user in reactedUsers {
            boolean? userBotOptional = user?.bot;
            boolean userIsBot = userBotOptional ?: false;
            if !userIsBot {
                humanReactions += 1;
            }
        }
        
        io:println(string `\nActivity Assessment: ${humanReactions} human reactions detected`);
        
        if humanReactions < 5 {
            io:println("⚠ LOW ACTIVITY: This channel may be a candidate for archival");
        } else if humanReactions < 20 {
            io:println("📊 MODERATE ACTIVITY: Channel has some engagement");
        } else {
            io:println("✅ HIGH ACTIVITY: Channel is actively used");
        }
    } else {
        io:println("⚠ No reactions found - this message/channel may be inactive");
        io:println("   Consider this channel as a candidate for cleanup or archival");
    }
    
    // Step 3: Archival and cleanup recommendations
    io:println("\n------------------------");
    io:println("Step 3: Cleanup and Archival Recommendations\n");
    
    io:println("Based on the analysis, here are the recommended actions:");
    io:println("");
    io:println("For inactive channels:");
    io:println("  1. Export message history for archival purposes");
    io:println("  2. Move channel to an 'Archive' category");
    io:println("  3. Set channel permissions to read-only");
    io:println("  4. Consider bulk message deletion for old content");
    io:println("");
    io:println("Note: Discord's bulk delete endpoint can remove up to 100 messages");
    io:println("      that are less than 14 days old in a single API call.");
    io:println("");
    io:println("=== Workflow Complete ===");
}

// Helper function to get a human-readable channel type label
function getChannelTypeLabel(int channelType) returns string {
    match channelType {
        0 => { return "Text"; }
        1 => { return "DM"; }
        2 => { return "Voice"; }
        3 => { return "Group DM"; }
        4 => { return "Category"; }
        5 => { return "Announcement"; }
        10 => { return "Announcement Thread"; }
        11 => { return "Public Thread"; }
        12 => { return "Private Thread"; }
        13 => { return "Stage Voice"; }
        14 => { return "Directory"; }
        15 => { return "Forum"; }
        _ => { return "Unknown"; }
    }
}