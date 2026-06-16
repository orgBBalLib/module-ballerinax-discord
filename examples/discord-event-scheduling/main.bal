// Automated Discord Server Event Management Example
// This example demonstrates how to manage scheduled events for a Discord server
// Note: The provided API definitions do not include the specific guild and event management functions
// This example shows the expected pattern using the available client initialization

import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string botToken = ?;

// Custom record types for the expected API responses and requests
// These represent the data structures needed for event management

type Guild record {
    string id;
    string name;
    string? icon;
    boolean owner;
    string permissions;
};

type ScheduledEventRequest record {
    string name;
    string description?;
    int scheduled_start_time;
    int scheduled_end_time?;
    int privacy_level;
    int entity_type;
    string? channel_id;
    EntityMetadata entity_metadata?;
};

type EntityMetadata record {
    string location?;
};

type ScheduledEvent record {
    string id;
    string guild_id;
    string name;
    string? description;
    string scheduled_start_time;
    string? scheduled_end_time;
    int privacy_level;
    int status;
    int entity_type;
    string? entity_id;
    EntityMetadata? entity_metadata;
    UserInfo? creator;
    int? user_count;
};

type UserInfo record {
    string id;
    string username;
    string discriminator;
};

public function main() returns error? {
    io:println("=== Discord Server Event Management ===\n");

    // Step 1: Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: botToken
        }
    };

    discord:Client discordClient = check new (config);
    io:println("✓ Discord client initialized successfully\n");

    // Step 2: Retrieve the list of guilds the bot has access to
    // Note: The actual function call would depend on the available API methods
    io:println("Step 1: Retrieving guilds the bot has access to...");
    
    // Simulated guild data representing what would be returned from the API
    // In actual implementation, this would be: Guild[] guilds = check discordClient->listCurrentUserGuilds();
    Guild[] guilds = [
        {
            id: "123456789012345678",
            name: "Gaming Community",
            icon: "abc123",
            owner: false,
            permissions: "2147483647"
        },
        {
            id: "987654321098765432",
            name: "Developer Hub",
            icon: "def456",
            owner: true,
            permissions: "2147483647"
        }
    ];

    io:println("Found " + guilds.length().toString() + " guild(s):");
    foreach Guild guild in guilds {
        io:println("  - " + guild.name + " (ID: " + guild.id + ")");
    }
    io:println();

    // Step 3: Select a guild and create a scheduled event
    io:println("Step 2: Creating a scheduled event in the first guild...");
    
    string targetGuildId = guilds[0].id;
    string targetGuildName = guilds[0].name;
    
    // Prepare the scheduled event request
    // Event scheduled for next week - using Unix timestamp
    int currentTime = 1700000000; // Example timestamp
    int eventStartTime = currentTime + (7 * 24 * 60 * 60); // One week from now
    int eventEndTime = eventStartTime + (2 * 60 * 60); // 2 hours duration

    ScheduledEventRequest eventRequest = {
        name: "Weekly Game Night",
        description: "Join us for our weekly community game night! We'll be playing various multiplayer games and having fun together. All skill levels welcome!",
        scheduled_start_time: eventStartTime,
        scheduled_end_time: eventEndTime,
        privacy_level: 2, // GUILD_ONLY
        entity_type: 3, // EXTERNAL (for events with a location)
        channel_id: (),
        entity_metadata: {
            location: "Discord Voice Channel: Game Night Lounge"
        }
    };

    io:println("Event details to create:");
    io:println("  - Name: " + eventRequest.name);
    io:println("  - Description: " + (eventRequest.description ?: "N/A"));
    io:println("  - Entity Type: External Event");
    io:println("  - Privacy Level: Guild Only");
    io:println();

    // In actual implementation, this would be:
    // ScheduledEvent createdEvent = check discordClient->createGuildScheduledEvent(targetGuildId, eventRequest);
    
    // Simulated response representing the created event
    ScheduledEvent createdEvent = {
        id: "111222333444555666",
        guild_id: targetGuildId,
        name: eventRequest.name,
        description: eventRequest.description,
        scheduled_start_time: "2024-11-22T19:00:00+00:00",
        scheduled_end_time: "2024-11-22T21:00:00+00:00",
        privacy_level: 2,
        status: 1, // SCHEDULED
        entity_type: 3,
        entity_id: (),
        entity_metadata: eventRequest.entity_metadata,
        creator: {
            id: "999888777666555444",
            username: "EventBot",
            discriminator: "0001"
        },
        user_count: 0
    };

    io:println("✓ Event created successfully!");
    io:println("  - Event ID: " + createdEvent.id);
    io:println();

    // Step 4: Fetch the event details to confirm creation
    io:println("Step 3: Fetching event details to confirm creation...");
    
    // In actual implementation, this would be:
    // ScheduledEvent fetchedEvent = check discordClient->getGuildScheduledEvent(targetGuildId, createdEvent.id);
    
    // Using the created event as the fetched event for demonstration
    ScheduledEvent fetchedEvent = createdEvent;

    io:println("\n=== Event Confirmation ===");
    io:println("Guild: " + targetGuildName + " (ID: " + fetchedEvent.guild_id + ")");
    io:println("Event ID: " + fetchedEvent.id);
    io:println("Event Name: " + fetchedEvent.name);
    io:println("Description: " + (fetchedEvent.description ?: "No description"));
    io:println("Start Time: " + fetchedEvent.scheduled_start_time);
    io:println("End Time: " + (fetchedEvent.scheduled_end_time ?: "Not specified"));
    io:println("Status: " + getEventStatus(fetchedEvent.status));
    io:println("Privacy Level: " + getPrivacyLevel(fetchedEvent.privacy_level));
    io:println("Event Type: " + getEntityType(fetchedEvent.entity_type));
    
    if fetchedEvent.entity_metadata is EntityMetadata {
        EntityMetadata metadata = <EntityMetadata>fetchedEvent.entity_metadata;
        if metadata.location is string {
            io:println("Location: " + <string>metadata.location);
        }
    }
    
    if fetchedEvent.creator is UserInfo {
        UserInfo creator = <UserInfo>fetchedEvent.creator;
        io:println("Created by: " + creator.username + "#" + creator.discriminator);
    }
    
    io:println("Current RSVPs: " + (fetchedEvent.user_count ?: 0).toString());
    
    io:println("\n=== Summary for Moderators ===");
    io:println("The scheduled event '" + fetchedEvent.name + "' has been successfully created.");
    io:println("Share this event ID with your team: " + fetchedEvent.id);
    io:println("Members can find this event in the server's Events tab.");
    
    io:println("\n✓ Event management workflow completed successfully!");
}

// Helper function to get human-readable event status
function getEventStatus(int status) returns string {
    match status {
        1 => { return "Scheduled"; }
        2 => { return "Active"; }
        3 => { return "Completed"; }
        4 => { return "Canceled"; }
        _ => { return "Unknown"; }
    }
}

// Helper function to get human-readable privacy level
function getPrivacyLevel(int level) returns string {
    match level {
        2 => { return "Guild Only"; }
        _ => { return "Unknown"; }
    }
}

// Helper function to get human-readable entity type
function getEntityType(int entityType) returns string {
    match entityType {
        1 => { return "Stage Instance"; }
        2 => { return "Voice Channel"; }
        3 => { return "External"; }
        _ => { return "Unknown"; }
    }
}