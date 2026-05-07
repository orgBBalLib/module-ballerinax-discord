import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Automated Guild Role Management System ===\n");

    // Step 1: Retrieve all existing roles in the guild
    io:println("Step 1: Retrieving all existing roles in the guild...");
    discord:GuildRoleResponse[] existingRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Found ", existingRoles.length(), " existing roles:");
    foreach discord:GuildRoleResponse role in existingRoles {
        io:println("  - Name: ", role.name, " | ID: ", role.id, " | Position: ", role.position, " | Color: ", role.color);
    }
    io:println();

    // Step 2: Create a new custom role for a new team/project
    io:println("Step 2: Creating a new custom role for the 'Project Alpha Team'...");
    
    // Define the new role configuration
    // Color: 0x3498DB (Blue) = 3447003 in decimal
    // Permissions: Basic permissions for team members (view channels, send messages, etc.)
    // Permission value 1024 allows VIEW_CHANNEL permission
    discord:GuildsRolesRequest newRolePayload = {
        name: "Project Alpha Team",
        color: 3447003,
        hoist: true,
        mentionable: true,
        permissions: 1024
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

    // Step 3: Update the role to modify its properties (simulating hierarchy adjustment)
    io:println("Step 3: Updating the role properties to ensure proper hierarchy...");
    
    // Update the role with enhanced permissions and a different color
    // Color: 0x9B59B6 (Purple) = 10181046 in decimal
    // Permissions: Enhanced permissions including sending messages (2048)
    discord:GuildsRolesRequest updateRolePayload = {
        name: "Project Alpha Team - Lead",
        color: 10181046,
        hoist: true,
        mentionable: true,
        permissions: 2048
    };

    discord:GuildRoleResponse updatedRole = check discordClient->/guilds/[guildId]/roles/[createdRole.id].patch(updateRolePayload);
    
    io:println("Successfully updated role:");
    io:println("  - Name: ", updatedRole.name);
    io:println("  - ID: ", updatedRole.id);
    io:println("  - Color: ", updatedRole.color);
    io:println("  - Hoisted: ", updatedRole.hoist);
    io:println("  - Mentionable: ", updatedRole.mentionable);
    io:println("  - Position: ", updatedRole.position);
    io:println();

    // Step 4: Verify the final role structure by retrieving all roles again
    io:println("Step 4: Verifying final role structure...");
    discord:GuildRoleResponse[] finalRoles = check discordClient->/guilds/[guildId]/roles();
    
    io:println("Final role hierarchy (", finalRoles.length(), " roles):");
    
    // Sort roles by position for display (higher position = higher in hierarchy)
    discord:GuildRoleResponse[] sortedRoles = from discord:GuildRoleResponse r in finalRoles
        order by r.position descending
        select r;
    
    foreach discord:GuildRoleResponse role in sortedRoles {
        string managedIndicator = role.managed ? " [Managed]" : "";
        io:println("  Position ", role.position, ": ", role.name, " (ID: ", role.id, ")", managedIndicator);
    }
    
    io:println();
    io:println("=== Guild Role Management Complete ===");
    io:println("The new role '", updatedRole.name, "' has been successfully created and configured.");
}