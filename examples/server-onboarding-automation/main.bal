import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Sample channel IDs for onboarding configuration
configurable string welcomeChannelId = ?;
configurable string rulesChannelId = ?;
configurable string generalChannelId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Server Onboarding System ===\n");

    // Step 1: Retrieve the current guild's onboarding configuration
    io:println("Step 1: Fetching current onboarding configuration...");
    discord:UserGuildOnboardingResponse currentOnboarding = check discordClient->/guilds/[guildId]/onboarding();
    
    io:println("Current Onboarding Status:");
    io:println("  - Guild ID: " + currentOnboarding.guildId);
    io:println("  - Onboarding Enabled: " + currentOnboarding.enabled.toString());
    io:println("  - Number of Prompts: " + currentOnboarding.prompts.length().toString());
    io:println("  - Default Channels: " + currentOnboarding.defaultChannelIds.length().toString());

    // Display existing prompts if any
    if currentOnboarding.prompts.length() > 0 {
        io:println("\nExisting Prompts:");
        foreach discord:OnboardingPromptResponse prompt in currentOnboarding.prompts {
            io:println("  - " + prompt.title + " (ID: " + prompt.id + ")");
            io:println("    Type: " + prompt.'type.toString());
            io:println("    Required: " + prompt.required.toString());
            io:println("    Options: " + prompt.options.length().toString());
        }
    }

    // Step 2: Prepare updated onboarding configuration with new prompts
    io:println("\nStep 2: Preparing updated onboarding configuration...");

    // Create prompt options for interests selection
    discord:OnboardingPromptOptionRequest gamingOption = {
        id: "gaming_option",
        title: "Gaming",
        description: "Join our gaming community discussions",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "🎮",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest techOption = {
        id: "tech_option",
        title: "Technology",
        description: "Discuss the latest in tech and development",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "💻",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest artOption = {
        id: "art_option",
        title: "Art & Creative",
        description: "Share and discuss creative works",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "🎨",
        emojiAnimated: false
    };

    // Create the interests prompt using UpdateOnboardingPromptRequest type
    discord:UpdateOnboardingPromptRequest interestsPrompt = {
        id: "interests_prompt",
        title: "What are your interests?",
        'type: 0,
        options: [gamingOption, techOption, artOption],
        singleSelect: false,
        required: true,
        inOnboarding: true
    };

    // Create prompt options for notification preferences
    discord:OnboardingPromptOptionRequest allNotificationsOption = {
        id: "all_notifications_option",
        title: "All Notifications",
        description: "Receive all server announcements and updates",
        channelIds: [],
        roleIds: [],
        emojiName: "🔔",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest minimalNotificationsOption = {
        id: "minimal_notifications_option",
        title: "Minimal Notifications",
        description: "Only receive important announcements",
        channelIds: [],
        roleIds: [],
        emojiName: "🔕",
        emojiAnimated: false
    };

    // Create the notification preferences prompt using UpdateOnboardingPromptRequest type
    discord:UpdateOnboardingPromptRequest notificationPrompt = {
        id: "notification_prompt",
        title: "How would you like to be notified?",
        'type: 1,
        options: [allNotificationsOption, minimalNotificationsOption],
        singleSelect: true,
        required: true,
        inOnboarding: true
    };

    // Prepare the update request with new prompts and default channels
    discord:UpdateGuildOnboardingRequest updateRequest = {
        prompts: [interestsPrompt, notificationPrompt],
        defaultChannelIds: [welcomeChannelId, rulesChannelId, generalChannelId],
        enabled: true,
        mode: 0
    };

    io:println("Update request prepared with:");
    io:println("  - 2 new onboarding prompts");
    io:println("  - 3 default channels for new members");
    io:println("  - Onboarding enabled: true");

    // Step 3: Update the guild's onboarding configuration
    io:println("\nStep 3: Updating onboarding configuration...");
    discord:GuildOnboardingResponse updatedOnboarding = check discordClient->/guilds/[guildId]/onboarding.put(updateRequest);

    io:println("\n=== Onboarding Update Successful! ===");
    io:println("Updated Configuration:");
    io:println("  - Guild ID: " + updatedOnboarding.guildId);
    io:println("  - Onboarding Enabled: " + updatedOnboarding.enabled.toString());
    io:println("  - Total Prompts: " + updatedOnboarding.prompts.length().toString());
    io:println("  - Default Channels: " + updatedOnboarding.defaultChannelIds.length().toString());

    // Display the updated prompts
    io:println("\nUpdated Prompts:");
    foreach discord:OnboardingPromptResponse prompt in updatedOnboarding.prompts {
        io:println("  📋 " + prompt.title);
        discord:OnboardingPromptType promptType = prompt.'type;
        string promptTypeDisplay = promptType == 0 ? "Multiple Choice" : "Dropdown";
        io:println("     - Type: " + promptTypeDisplay);
        io:println("     - Required: " + prompt.required.toString());
        io:println("     - In Onboarding: " + prompt.inOnboarding.toString());
        io:println("     - Options:");
        foreach discord:OnboardingPromptOptionResponse option in prompt.options {
            io:println("       • " + option.title + ": " + option.description);
        }
    }

    // Display default channels
    io:println("\nDefault Channels for New Members:");
    foreach string channelId in updatedOnboarding.defaultChannelIds {
        io:println("  - Channel ID: " + channelId);
    }

    io:println("\n=== Onboarding System Configuration Complete ===");
    io:println("New members will now see the updated onboarding flow when joining your server!");
}