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
    
    io:println("=== Automated Guild Role Management System ===\n");
    
    // Step 1: Retrieve all existing roles in the Discord server (guild)
    io:println("Step 1: Retrieving all roles in the guild...");
    
    discord:GuildRoleResponse[] existingRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Found ", existingRoles.length(), " roles in the guild:");
    foreach discord:GuildRoleResponse role in existingRoles {
        io:println("  - Role: ", role.name, " (ID: ", role.id, ", Position: ", role.position, ")");
    }
    io:println();
    
    // Step 2: Create a new moderation role with specific permissions
    io:println("Step 2: Creating a new moderation team role...");
    
    // Define the moderation role configuration
    // Permissions value 8198 includes: KICK_MEMBERS (2), BAN_MEMBERS (4), MANAGE_MESSAGES (8192)
    // Color value 3447003 represents a blue color (#3498DB)
    discord:GuildsRolesRequest moderationRolePayload = {
        name: "Moderation Team",
        color: 3447003,
        hoist: true,
        mentionable: true,
        permissions: 8198
    };
    
    discord:GuildRoleResponse newRole = check discordClient->/guilds/[guildId]/roles.post(moderationRolePayload);
    
    io:println("Successfully created new role:");
    io:println("  - Name: ", newRole.name);
    io:println("  - ID: ", newRole.id);
    io:println("  - Color: ", newRole.color);
    io:println("  - Hoisted: ", newRole.hoist);
    io:println("  - Mentionable: ", newRole.mentionable);
    io:println("  - Permissions: ", newRole.permissions);
    io:println();
    
    // Step 3: Assign the newly created role to the specified guild member
    io:println("Step 3: Assigning the moderation role to user ID: ", targetUserId, "...");
    
    string createdRoleId = newRole.id;
    check discordClient->/guilds/[guildId]/members/[targetUserId]/roles/[createdRoleId].put();
    
    io:println("Successfully assigned the '", newRole.name, "' role to user ID: ", targetUserId);
    io:println();
    
    // Step 4: Verify the role was created by fetching updated role list
    io:println("Step 4: Verifying role creation by fetching updated role list...");
    
    discord:GuildRoleResponse[] updatedRoles = check discordClient->/guilds/[guildId]/roles();
    
    boolean roleFound = false;
    foreach discord:GuildRoleResponse role in updatedRoles {
        if role.id == createdRoleId {
            roleFound = true;
            io:println("Verification successful! Role '", role.name, "' exists in the guild.");
            break;
        }
    }
    
    if !roleFound {
        io:println("Warning: Could not verify the role in the updated list.");
    }
    
    io:println();
    io:println("=== Guild Role Management Complete ===");
    io:println("Summary:");
    io:println("  - Total roles in guild: ", updatedRoles.length());
    io:println("  - New moderation role ID: ", createdRoleId);
    io:println("  - Role assigned to user: ", targetUserId);
}