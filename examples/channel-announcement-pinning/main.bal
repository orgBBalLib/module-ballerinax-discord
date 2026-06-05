import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string botToken = ?;

// Channel and message configuration
configurable string channelId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: botToken
        }
    });

    io:println("=== Automated Discord Channel Announcement System ===\n");

    // Step 1: Retrieve channel details to verify it exists and check archived threads
    io:println("Step 1: Verifying channel access by retrieving archived threads...");
    
    discord:ThreadsResponse|error threadsResponse = discordClient->/channels/[channelId]/users/\@me/threads/archived/'private();
    
    if threadsResponse is error {
        io:println("Note: Could not retrieve private archived threads (this is normal for channels without threads)");
        io:println("Proceeding with announcement posting...\n");
    } else {
        io:println("Channel access verified successfully!");
        discord:ThreadResponse[]? threadsList = threadsResponse?.threads;
        if threadsList is discord:ThreadResponse[] {
            io:println("Found " + threadsList.length().toString() + " archived threads");
        }
        boolean? hasMoreValue = threadsResponse?.hasMore;
        if hasMoreValue is boolean {
            io:println("Has more threads: " + hasMoreValue.toString());
        }
        io:println();
    }

    // Step 2: For demonstration, we'll work with an existing message ID
    string announcementMessageId = "1234567890123456789";
    
    io:println("Step 2: Pinning the announcement message for visibility...");
    io:println("Channel ID: " + channelId);
    io:println("Message ID to pin: " + announcementMessageId);
    
    // Pin the announcement message so community members can easily find it
    error? pinResult = discordClient->/channels/[channelId]/pins/[announcementMessageId].put();
    
    if pinResult is error {
        io:println("Error pinning message: " + pinResult.message());
        io:println("Note: Ensure the message ID exists and the bot has 'Manage Messages' permission");
    } else {
        io:println("Message pinned successfully!");
        io:println("Community members can now find this announcement in the pinned messages.");
    }
    
    io:println("\n=== Announcement Workflow Complete ===");
    io:println("\nWorkflow Summary:");
    io:println("1. Verified channel access");
    io:println("2. Pinned announcement message for visibility");
    io:println("\nThis pattern is ideal for:");
    io:println("- Server rules and guidelines");
    io:println("- Event announcements");
    io:println("- Important updates that need to remain accessible");
}