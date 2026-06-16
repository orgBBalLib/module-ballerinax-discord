import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;
configurable string webhookId = ?;
configurable string webhookToken = ?;

// Sample user IDs to check for bans (in a real scenario, these would come from audit logs or a database)
configurable string[] userIdsToCheck = ["123456789012345678", "234567890123456789", "345678901234567890"];

public function main() returns error? {
    io:println("=== Discord Guild Audit and Moderation Report Generator ===\n");

    // Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: discordBotToken
        }
    };
    
    discord:Client discordClient = check new (config);
    io:println("Discord client initialized successfully.\n");

    // Step 1: Fetch ban information for specified users
    io:println("--- Step 1: Retrieving Ban Information ---");
    
    string[] activeBans = [];
    string[] banReasons = [];
    
    foreach string userId in userIdsToCheck {
        discord:GuildBanResponse|error banResponse = discordClient->/guilds/[guildId]/bans/[userId]();
        
        if banResponse is discord:GuildBanResponse {
            discord:UserResponse userInfo = banResponse.user;
            string username = userInfo.username;
            string? globalNameOptional = <string?>userInfo["global_name"];
            string globalName = globalNameOptional ?: "N/A";
            string? reasonOptional = banResponse?.reason;
            string reason = reasonOptional ?: "No reason provided";
            
            activeBans.push(userId);
            banReasons.push(string `User: ${username} (${globalName}) - Reason: ${reason}`);
            
            io:println(string `  ✓ Found ban for user ${userId}: ${username}`);
            io:println(string `    Reason: ${reason}`);
        } else {
            io:println(string `  ○ No ban found for user ${userId}`);
        }
    }
    
    io:println(string `\nTotal active bans found: ${activeBans.length()}\n`);

    // Step 2: Compile the moderation report
    io:println("--- Step 2: Compiling Moderation Report ---");
    
    string reportSummary = generateModerationReport(activeBans, banReasons);
    io:println("Moderation report compiled successfully.\n");
    io:println("Report Preview:");
    io:println(reportSummary);

    // Step 3: Post the report to the admin channel via webhook
    io:println("\n--- Step 3: Posting Report via Webhook ---");
    
    // Create a GitHub-compatible webhook payload for posting the report
    // Using the GitHub webhook format as it's available in the API
    discord:GithubWebhook webhookPayload = {
        sender: {
            avatarUrl: "https://cdn.discordapp.com/embed/avatars/0.png",
            htmlUrl: "https://discord.com",
            id: 1,
            login: "ModerationBot"
        },
        action: "moderation_report",
        ref: string `Guild: ${guildId}`,
        refType: "report",
        compare: reportSummary
    };
    
    error? webhookResult = discordClient->/webhooks/[webhookId]/[webhookToken]/github.post(webhookPayload);
    
    if webhookResult is error {
        io:println(string `  ⚠ Warning: Could not post via GitHub webhook format: ${webhookResult.message()}`);
        io:println("  Note: For full moderation reports, consider using the standard webhook endpoint.");
    } else {
        io:println("  ✓ Moderation report posted successfully to admin channel!");
    }

    io:println("\n=== Moderation Report Generation Complete ===");
    
    // Print final summary
    io:println("\n--- Final Summary ---");
    io:println(string `Guild ID: ${guildId}`);
    io:println(string `Users Checked: ${userIdsToCheck.length()}`);
    io:println(string `Active Bans Found: ${activeBans.length()}`);
    io:println("Report Status: Generated");
}

// Helper function to generate a formatted moderation report
function generateModerationReport(string[] activeBans, string[] banReasons) returns string {
    string report = "╔══════════════════════════════════════════╗\n";
    report += "║     GUILD MODERATION REPORT              ║\n";
    report += "╚══════════════════════════════════════════╝\n\n";
    
    report += "📊 REPORT SUMMARY\n";
    report += "─────────────────────────────────────────\n";
    report += string `Total Users Analyzed: ${activeBans.length() + 3}${"\n"}`;
    report += string `Active Bans: ${activeBans.length()}${"\n\n"}`;
    
    if activeBans.length() > 0 {
        report += "🔨 ACTIVE BANS\n";
        report += "─────────────────────────────────────────\n";
        
        foreach int i in 0 ..< banReasons.length() {
            report += string `${i + 1}. ${banReasons[i]}${"\n"}`;
        }
        report += "\n";
    } else {
        report += "✅ No active bans found for checked users.\n\n";
    }
    
    report += "📝 RECOMMENDATIONS\n";
    report += "─────────────────────────────────────────\n";
    
    if activeBans.length() > 5 {
        report += "• High ban count detected. Review ban policies.\n";
    } else if activeBans.length() > 0 {
        report += "• Ban count within normal range.\n";
    } else {
        report += "• Server moderation appears stable.\n";
    }
    
    report += "• Regular audit log reviews recommended.\n";
    report += "• Ensure all bans have documented reasons.\n\n";
    
    report += "─────────────────────────────────────────\n";
    report += "Report generated by Discord Moderation Bot\n";
    
    return report;
}