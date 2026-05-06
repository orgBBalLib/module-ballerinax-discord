import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Define emoji IDs to manage - in a real scenario, these would be retrieved from a list endpoint
// For this example, we define sample emoji IDs to demonstrate the workflow
configurable string[] emojiIdsToAudit = ?;

// Naming convention patterns for emoji management
const string DEPRECATED_PREFIX = "old_";
const string OUTDATED_PREFIX = "legacy_";
const string STANDARD_PREFIX = "emoji_";

public function main() returns error? {
    io:println("=== Discord Guild Emoji Management System ===\n");

    // Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: discordBotToken
        }
    };
    discord:Client discordClient = check new (config);

    io:println("Discord client initialized successfully.");
    io:println("Guild ID: ", guildId);
    io:println("Number of emojis to audit: ", emojiIdsToAudit.length());
    io:println("\n--- Starting Emoji Audit ---\n");

    // Arrays to track emojis by category
    string[] emojisToUpdate = [];
    string[] emojisToDelete = [];
    string[] emojisUpToDate = [];

    // Step 1: Fetch and audit each emoji
    foreach string emojiId in emojiIdsToAudit {
        io:println("Fetching emoji with ID: ", emojiId);
        
        discord:EmojiResponse|error emojiResponse = discordClient->/guilds/[guildId]/emojis/[emojiId]();
        
        if emojiResponse is error {
            io:println("  Error fetching emoji: ", emojiResponse.message());
            continue;
        }

        string? emojiName = emojiResponse.name;
        string displayName = emojiName is string ? emojiName : "Unknown";
        io:println("  Emoji Name: ", displayName);
        
        boolean? animatedValue = emojiResponse.animated;
        boolean isAnimated = animatedValue is boolean ? animatedValue : false;
        io:println("  Animated: ", isAnimated);

        // Categorize emoji based on naming conventions
        if emojiName is string {
            if emojiName.startsWith(DEPRECATED_PREFIX) {
                io:println("  Status: DEPRECATED - Marked for deletion");
                emojisToDelete.push(emojiId);
            } else if emojiName.startsWith(OUTDATED_PREFIX) {
                io:println("  Status: OUTDATED - Needs renaming for consistency");
                emojisToUpdate.push(emojiId);
            } else if !emojiName.startsWith(STANDARD_PREFIX) {
                io:println("  Status: NON-STANDARD - Needs prefix update");
                emojisToUpdate.push(emojiId);
            } else {
                io:println("  Status: UP-TO-DATE - No action needed");
                emojisUpToDate.push(emojiId);
            }
        }
        io:println();
    }

    // Summary of audit results
    io:println("--- Audit Summary ---");
    io:println("Emojis up to date: ", emojisUpToDate.length());
    io:println("Emojis to update: ", emojisToUpdate.length());
    io:println("Emojis to delete: ", emojisToDelete.length());
    io:println();

    // Step 2: Update emojis that need renaming or metadata changes
    if emojisToUpdate.length() > 0 {
        io:println("--- Updating Emoji Metadata ---\n");
        
        foreach string emojiId in emojisToUpdate {
            // First, fetch current emoji details
            discord:EmojiResponse|error currentEmoji = discordClient->/guilds/[guildId]/emojis/[emojiId]();
            
            if currentEmoji is error {
                io:println("Error fetching emoji ", emojiId, " for update: ", currentEmoji.message());
                continue;
            }

            string? currentName = currentEmoji.name;
            string newName = STANDARD_PREFIX;
            
            // Generate new standardized name
            if currentName is string {
                if currentName.startsWith(OUTDATED_PREFIX) {
                    newName = STANDARD_PREFIX + currentName.substring(OUTDATED_PREFIX.length());
                } else {
                    newName = STANDARD_PREFIX + currentName;
                }
            } else {
                newName = STANDARD_PREFIX + "unnamed_" + emojiId;
            }

            // Ensure name meets length constraints (2-32 characters)
            if newName.length() > 32 {
                newName = newName.substring(0, 32);
            }

            string currentDisplayName = currentName is string ? currentName : "Unknown";
            io:println("Updating emoji: ", currentDisplayName, " -> ", newName);

            // Create update request payload
            discord:GuildsEmojisRequest updatePayload = {
                name: newName
            };

            // Patch the emoji with new metadata
            discord:EmojiResponse|error updateResult = discordClient->/guilds/[guildId]/emojis/[emojiId].patch(updatePayload);
            
            if updateResult is error {
                io:println("  Error updating emoji: ", updateResult.message());
            } else {
                string? updatedName = updateResult.name;
                string updatedDisplayName = updatedName is string ? updatedName : "Unknown";
                io:println("  Successfully updated emoji to: ", updatedDisplayName);
            }
            io:println();
        }
    }

    // Step 3: Delete deprecated emojis
    if emojisToDelete.length() > 0 {
        io:println("--- Deleting Deprecated Emojis ---\n");
        
        foreach string emojiId in emojisToDelete {
            io:println("Deleting emoji with ID: ", emojiId);
            
            error? deleteResult = discordClient->/guilds/[guildId]/emojis/[emojiId].delete();
            
            if deleteResult is error {
                io:println("  Error deleting emoji: ", deleteResult.message());
            } else {
                io:println("  Successfully deleted emoji");
            }
            io:println();
        }
    }

    // Final summary
    io:println("=== Emoji Management Complete ===");
    io:println("Total emojis processed: ", emojiIdsToAudit.length());
    io:println("Emojis updated: ", emojisToUpdate.length());
    io:println("Emojis deleted: ", emojisToDelete.length());
    io:println("Emojis unchanged: ", emojisUpToDate.length());
}