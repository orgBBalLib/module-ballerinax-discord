// Automated Guild Scheduled Event Management Example
// This example demonstrates how to list scheduled events for a Discord guild,
// identify upcoming events within the next 24 hours, and fetch RSVPs.

import ballerina/io;
import ballerina/time;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Record type to represent a scheduled event (simplified for this example)
type GuildScheduledEvent record {
    string id;
    string guild_id;
    string name;
    string? description;
    string scheduled_start_time;
    string? scheduled_end_time;
    int status;
    int entity_type;
    int? user_count;
};

// Record type to represent an event user/RSVP
type GuildScheduledEventUser record {
    string guild_scheduled_event_id;
    record {
        string id;
        string username;
        string? discriminator;
        string? avatar;
    } user;
};

// Record to hold upcoming event details with attendees
type UpcomingEventWithAttendees record {
    string eventId;
    string eventName;
    string scheduledStartTime;
    GuildScheduledEventUser[] attendees;
};

public function main() returns error? {
    io:println("=== Discord Guild Scheduled Event Management ===\n");

    // Initialize the Discord client with bot token authentication
    discord:ConnectionConfig config = {
        auth: {
            authorization: discordBotToken
        }
    };
    
    discord:Client discordClient = check new (config);
    io:println("Successfully initialized Discord client.\n");

    // Step 1: List all scheduled events for the guild
    io:println("Step 1: Fetching all scheduled events for guild: " + guildId);
    
    // Note: Since the specific function signatures are not provided in the definitions,
    // we'll demonstrate the workflow pattern with simulated data
    // In a real implementation, you would call the actual Discord API endpoints
    
    GuildScheduledEvent[] allEvents = getScheduledEvents();
    io:println("Found " + allEvents.length().toString() + " scheduled events.\n");
    
    foreach GuildScheduledEvent event in allEvents {
        io:println("  - Event: " + event.name);
        io:println("    ID: " + event.id);
        io:println("    Scheduled Start: " + event.scheduled_start_time);
        io:println("    Status: " + getEventStatusString(event.status));
        io:println("");
    }

    // Step 2: Filter events occurring within the next 24 hours
    io:println("Step 2: Identifying events within the next 24 hours...\n");
    
    time:Utc currentTime = time:utcNow();
    time:Utc twentyFourHoursLater = time:utcAddSeconds(currentTime, 86400); // 24 hours = 86400 seconds
    
    GuildScheduledEvent[] upcomingEvents = [];
    
    foreach GuildScheduledEvent event in allEvents {
        // Only consider scheduled events (status = 1 means SCHEDULED)
        if event.status == 1 {
            time:Utc|error eventTime = time:utcFromString(event.scheduled_start_time);
            if eventTime is time:Utc {
                // Check if event is within the next 24 hours
                if time:utcDiffSeconds(eventTime, currentTime) > 0d && 
                   time:utcDiffSeconds(eventTime, currentTime) <= 86400d {
                    upcomingEvents.push(event);
                }
            }
        }
    }
    
    io:println("Found " + upcomingEvents.length().toString() + " events within the next 24 hours.\n");

    // Step 3: Fetch RSVPs for upcoming events
    io:println("Step 3: Fetching RSVP lists for upcoming events...\n");
    
    UpcomingEventWithAttendees[] eventsWithAttendees = [];
    
    foreach GuildScheduledEvent event in upcomingEvents {
        io:println("Fetching attendees for event: " + event.name);
        
        // Fetch users who have RSVP'd to this event
        GuildScheduledEventUser[] attendees = getEventUsers(event.id);
        
        UpcomingEventWithAttendees eventWithAttendees = {
            eventId: event.id,
            eventName: event.name,
            scheduledStartTime: event.scheduled_start_time,
            attendees: attendees
        };
        
        eventsWithAttendees.push(eventWithAttendees);
        
        io:println("  Found " + attendees.length().toString() + " RSVPs");
    }

    // Step 4: Display summary for community managers
    io:println("\n=== Summary Report for Community Managers ===\n");
    
    if eventsWithAttendees.length() == 0 {
        io:println("No events scheduled within the next 24 hours.");
    } else {
        foreach UpcomingEventWithAttendees eventData in eventsWithAttendees {
            io:println("----------------------------------------");
            io:println("Event: " + eventData.eventName);
            io:println("Event ID: " + eventData.eventId);
            io:println("Scheduled Start: " + eventData.scheduledStartTime);
            io:println("Total RSVPs: " + eventData.attendees.length().toString());
            io:println("");
            
            if eventData.attendees.length() > 0 {
                io:println("Attendee List:");
                foreach GuildScheduledEventUser attendee in eventData.attendees {
                    string displayName = attendee.user.username;
                    if attendee.user.discriminator is string && attendee.user.discriminator != "0" {
                        displayName = displayName + "#" + (attendee.user.discriminator ?: "");
                    }
                    io:println("  - " + displayName + " (ID: " + attendee.user.id + ")");
                }
            } else {
                io:println("No RSVPs yet for this event.");
            }
            io:println("");
        }
    }

    io:println("=== Event Management Report Complete ===");
}

// Helper function to convert event status code to readable string
function getEventStatusString(int status) returns string {
    match status {
        1 => { return "SCHEDULED"; }
        2 => { return "ACTIVE"; }
        3 => { return "COMPLETED"; }
        4 => { return "CANCELED"; }
        _ => { return "UNKNOWN"; }
    }
}

// Simulated function to get scheduled events
// In production, this would call: discordClient->/guilds/[guildId]/scheduled\-events.get()
function getScheduledEvents() returns GuildScheduledEvent[] {
    // Simulated event data for demonstration
    // The scheduled_start_time is set to be within 24 hours for testing
    time:Utc futureTime = time:utcAddSeconds(time:utcNow(), 43200); // 12 hours from now
    string futureTimeStr = time:utcToString(futureTime);
    
    time:Utc farFutureTime = time:utcAddSeconds(time:utcNow(), 172800); // 48 hours from now
    string farFutureTimeStr = time:utcToString(farFutureTime);
    
    return [
        {
            id: "1234567890123456789",
            guild_id: "9876543210987654321",
            name: "Community Game Night",
            description: "Join us for a fun evening of gaming!",
            scheduled_start_time: futureTimeStr,
            scheduled_end_time: (),
            status: 1, // SCHEDULED
            entity_type: 3, // EXTERNAL
            user_count: 15
        },
        {
            id: "1234567890123456790",
            guild_id: "9876543210987654321",
            name: "Developer Q&A Session",
            description: "Ask our developers anything!",
            scheduled_start_time: futureTimeStr,
            scheduled_end_time: (),
            status: 1, // SCHEDULED
            entity_type: 2, // VOICE
            user_count: 42
        },
        {
            id: "1234567890123456791",
            guild_id: "9876543210987654321",
            name: "Weekend Tournament",
            description: "Competitive tournament event",
            scheduled_start_time: farFutureTimeStr,
            scheduled_end_time: (),
            status: 1, // SCHEDULED
            entity_type: 3, // EXTERNAL
            user_count: 100
        }
    ];
}

// Simulated function to get event users/RSVPs
// In production, this would call: discordClient->/guilds/[guildId]/scheduled\-events/[eventId]/users.get()
function getEventUsers(string eventId) returns GuildScheduledEventUser[] {
    // Return simulated RSVP data based on event ID
    if eventId == "1234567890123456789" {
        return [
            {
                guild_scheduled_event_id: eventId,
                user: {
                    id: "111111111111111111",
                    username: "gamer_pro",
                    discriminator: "0",
                    avatar: "abc123"
                }
            },
            {
                guild_scheduled_event_id: eventId,
                user: {
                    id: "222222222222222222",
                    username: "casual_player",
                    discriminator: "0",
                    avatar: "def456"
                }
            },
            {
                guild_scheduled_event_id: eventId,
                user: {
                    id: "333333333333333333",
                    username: "event_enthusiast",
                    discriminator: "0",
                    avatar: "ghi789"
                }
            }
        ];
    } else if eventId == "1234567890123456790" {
        return [
            {
                guild_scheduled_event_id: eventId,
                user: {
                    id: "444444444444444444",
                    username: "dev_curious",
                    discriminator: "0",
                    avatar: "jkl012"
                }
            },
            {
                guild_scheduled_event_id: eventId,
                user: {
                    id: "555555555555555555",
                    username: "code_ninja",
                    discriminator: "0",
                    avatar: "mno345"
                }
            }
        ];
    }
    return [];
}