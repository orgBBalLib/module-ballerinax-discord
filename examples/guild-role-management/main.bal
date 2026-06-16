import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;

// Configurable variables for the guild and member to manage
configurable string guildId = ?;
configurable string targetUserId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: discordBotToken
        }
    };
    
    discord:Client discordClient = check new (config);
    
    io:println("=== Discord Guild Role Management System ===\n");
    
    // Step 1: Retrieve all existing roles in the guild
    io:println("Step 1: Fetching all roles in the guild...");
    discord:GuildRoleResponse[] existingRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Found ", existingRoles.length(), " roles in the guild:");
    foreach discord:GuildRoleResponse role in existingRoles {
        io:println("  - ", role.name, " (ID: ", role.id, ", Position: ", role.position, ")");
    }
    io:println();
    
    // Step 2: Create a new custom role for event participants
    io:println("Step 2: Creating a new custom role for event participants...");
    
    // Define the new role configuration
    // Color 3447003 is a nice blue color (hex: #3498DB)
    // Permissions 0 means no special permissions beyond default
    discord:GuildsRolesRequest newRolePayload = {
        name: "Event Participant",
        color: 3447003,
        hoist: true,
        mentionable: true,
        permissions: 0
    };
    
    discord:GuildRoleResponse createdRole = check discordClient->/guilds/[guildId]/roles.post(newRolePayload);
    
    io:println("Successfully created new role:");
    io:println("  - Name: ", createdRole.name);
    io:println("  - ID: ", createdRole.id);
    io:println("  - Color: ", createdRole.color);
    io:println("  - Hoisted: ", createdRole.hoist);
    io:println("  - Mentionable: ", createdRole.mentionable);
    io:println();
    
    // Step 3: Assign the newly created role to the specified guild member
    io:println("Step 3: Assigning the new role to the target user...");
    
    string newRoleId = createdRole.id;
    check discordClient->/guilds/[guildId]/members/[targetUserId]/roles/[newRoleId].put();
    
    io:println("Successfully assigned role '", createdRole.name, "' to user ID: ", targetUserId);
    io:println();
    
    // Step 4: Verify by fetching updated roles list
    io:println("Step 4: Verifying role creation by fetching updated roles list...");
    discord:GuildRoleResponse[] updatedRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Updated roles list (", updatedRoles.length(), " roles):");
    foreach discord:GuildRoleResponse role in updatedRoles {
        string marker = role.id == newRoleId ? " [NEW]" : "";
        io:println("  - ", role.name, " (ID: ", role.id, ")", marker);
    }
    io:println();
    
    io:println("=== Role Management Workflow Completed Successfully ===");
    io:println("Summary:");
    io:println("  - Retrieved ", existingRoles.length(), " existing roles");
    io:println("  - Created new role: '", createdRole.name, "' with ID: ", createdRole.id);
    io:println("  - Assigned role to user: ", targetUserId);
}