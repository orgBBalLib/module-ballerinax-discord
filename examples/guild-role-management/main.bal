// Automated Guild Role Management System for Discord
// This example demonstrates how to:
// 1. Retrieve all existing roles from a Discord guild
// 2. Create a new custom role with specific permissions for bot integration
// 3. Assign the newly created role to a specific member

import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication and guild details
configurable string botToken = ?;
configurable string guildId = ?;
configurable string targetUserId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: botToken
        }
    };
    
    discord:Client discordClient = check new (config);
    
    io:println("=== Discord Guild Role Management System ===\n");
    
    // Step 1: Retrieve all existing roles from the guild
    io:println("Step 1: Fetching all existing roles from the guild...");
    
    discord:GuildRoleResponse[] existingRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Found ", existingRoles.length(), " existing roles in the guild:");
    foreach discord:GuildRoleResponse role in existingRoles {
        io:println("  - Role: ", role.name, " (ID: ", role.id, ", Position: ", role.position, ")");
    }
    io:println();
    
    // Step 2: Create a new custom role for bot integration
    io:println("Step 2: Creating a new custom role for bot integration...");
    
    // Define the new role with specific permissions
    // Permissions value 268435456 represents "Manage Roles" permission
    // Color 3447003 is a blue color (hex: #3498DB)
    discord:GuildsRolesRequest newRolePayload = {
        name: "Bot Integration Role",
        color: 3447003,
        hoist: true,
        mentionable: false,
        permissions: 268435456
    };
    
    discord:GuildRoleResponse createdRole = check discordClient->/guilds/[guildId]/roles.post(newRolePayload);
    
    io:println("Successfully created new role:");
    io:println("  - Name: ", createdRole.name);
    io:println("  - ID: ", createdRole.id);
    io:println("  - Color: ", createdRole.color);
    io:println("  - Hoisted: ", createdRole.hoist);
    io:println("  - Mentionable: ", createdRole.mentionable);
    io:println("  - Position: ", createdRole.position);
    io:println();
    
    // Step 3: Assign the newly created role to a specific member
    io:println("Step 3: Assigning the new role to member with ID: ", targetUserId, "...");
    
    string newRoleId = createdRole.id;
    check discordClient->/guilds/[guildId]/members/[targetUserId]/roles/[newRoleId].put();
    
    io:println("Successfully assigned role '", createdRole.name, "' to member!");
    io:println();
    
    // Verify by fetching roles again to confirm the new role exists
    io:println("Step 4: Verifying role creation by fetching updated role list...");
    
    discord:GuildRoleResponse[] updatedRoles = check discordClient->/guilds/[guildId]/roles();
    
    boolean roleFound = false;
    foreach discord:GuildRoleResponse role in updatedRoles {
        if role.id == newRoleId {
            roleFound = true;
            io:println("Verification successful! Role '", role.name, "' exists in the guild.");
            break;
        }
    }
    
    if !roleFound {
        io:println("Warning: Could not verify role in the updated role list.");
    }
    
    io:println();
    io:println("=== Guild Role Management Complete ===");
    io:println("Summary:");
    io:println("  - Retrieved ", existingRoles.length(), " existing roles");
    io:println("  - Created new role: ", createdRole.name, " (ID: ", createdRole.id, ")");
    io:println("  - Assigned role to user: ", targetUserId);
}