import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string botToken = ?;
configurable string guildId = ?;

public function main() returns error? {
    io:println("=== Discord Server Cleanup Workflow ===\n");

    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: botToken
        }
    });

    // Step 1: Search for guild members to analyze activity patterns
    io:println("Step 1: Searching for guild members...");
    
    discord:SearchGuildMembersQueries memberSearchQueries = {
        query: "",
        'limit: 100
    };
    
    discord:GuildMemberResponse[] members = check discordClient->/guilds/[guildId]/members/search(queries = memberSearchQueries);
    
    io:println("Found " + members.length().toString() + " members matching the search criteria.");
    io:println("Member analysis complete.\n");

    // Step 2: Preview prune operation to estimate inactive members
    io:println("Step 2: Previewing prune operation...");
    
    // Configure prune preview for members inactive for 7 days
    discord:PreviewPruneGuildQueries prunePreviewQueries = {
        days: 7
    };
    
    discord:GuildPruneResponse prunePreview = check discordClient->/guilds/[guildId]/prune(queries = prunePreviewQueries);
    
    int? prunedValue = <int?>prunePreview["pruned"];
    int estimatedPruneCount = prunedValue ?: 0;
    io:println("Prune preview complete.");
    io:println("Estimated members to be pruned (inactive for 7+ days): " + estimatedPruneCount.toString());
    io:println();

    // Step 3: Execute prune operation if there are inactive members
    io:println("Step 3: Executing prune operation...");
    
    if estimatedPruneCount > 0 {
        // Prepare the prune request payload
        discord:GuildsPruneRequest pruneRequest = {
            days: 7,
            computePruneCount: true
        };
        
        discord:GuildPruneResponse pruneResult = check discordClient->/guilds/[guildId]/prune.post(pruneRequest);
        
        int? prunedResultValue = <int?>pruneResult["pruned"];
        int prunedCount = prunedResultValue ?: 0;
        io:println("Prune operation completed successfully!");
        io:println("Total members pruned: " + prunedCount.toString());
    } else {
        io:println("No inactive members found. Skipping prune operation.");
    }

    io:println("\n=== Server Cleanup Workflow Complete ===");
    io:println("Summary:");
    io:println("- Members analyzed: " + members.length().toString());
    io:println("- Inactive members identified: " + estimatedPruneCount.toString());
    io:println("- Server hygiene maintained successfully!");
}