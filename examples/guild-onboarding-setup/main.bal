import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord API authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Sample channel IDs for onboarding configuration
configurable string welcomeChannelId = ?;
configurable string rulesChannelId = ?;
configurable string generalChannelId = ?;
configurable string introductionsChannelId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Guild Onboarding Configuration ===\n");

    // Step 1: Retrieve the current onboarding configuration
    io:println("Step 1: Retrieving current onboarding configuration...");
    discord:UserGuildOnboardingResponse currentOnboarding = check discordClient->/guilds/[guildId]/onboarding();
    
    io:println("Current Onboarding Status:");
    io:println("  - Guild ID: " + currentOnboarding.guildId);
    io:println("  - Enabled: " + currentOnboarding.enabled.toString());
    io:println("  - Number of prompts: " + currentOnboarding.prompts.length().toString());
    io:println("  - Default channels count: " + currentOnboarding.defaultChannelIds.length().toString());
    
    // Display existing prompts if any
    if currentOnboarding.prompts.length() > 0 {
        io:println("\nExisting Prompts:");
        foreach discord:OnboardingPromptResponse prompt in currentOnboarding.prompts {
            io:println("  - " + prompt.title + " (Type: " + prompt.'type.toString() + ", Required: " + prompt.required.toString() + ")");
        }
    }

    // Step 2: Prepare and update the onboarding configuration with new settings
    io:println("\nStep 2: Updating onboarding configuration with new settings...");

    // Create onboarding prompt options for community interests
    discord:OnboardingPromptOptionRequest gamingOption = {
        title: "Gaming",
        description: "Join discussions about games and esports",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "🎮",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest artOption = {
        title: "Art & Design",
        description: "Share and discuss creative works",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "🎨",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest techOption = {
        title: "Technology",
        description: "Discuss tech topics and programming",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "💻",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest musicOption = {
        title: "Music",
        description: "Share and discover music",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "🎵",
        emojiAnimated: false
    };

    // Create onboarding prompt options for notification preferences
    discord:OnboardingPromptOptionRequest allNotificationsOption = {
        title: "All Announcements",
        description: "Receive all server announcements and updates",
        channelIds: [welcomeChannelId],
        roleIds: [],
        emojiName: "🔔",
        emojiAnimated: false
    };

    discord:OnboardingPromptOptionRequest importantOnlyOption = {
        title: "Important Only",
        description: "Only receive critical announcements",
        channelIds: [],
        roleIds: [],
        emojiName: "📢",
        emojiAnimated: false
    };

    // Create the onboarding prompts using the Discord module's UpdateOnboardingPromptRequest type
    // The 'id' field is required - using a placeholder ID for new prompts
    discord:UpdateOnboardingPromptRequest interestsPrompt = {
        id: "0",
        title: "What are your interests?",
        'type: 0,
        options: [gamingOption, artOption, techOption, musicOption],
        singleSelect: false,
        required: true,
        inOnboarding: true
    };

    discord:UpdateOnboardingPromptRequest notificationsPrompt = {
        id: "1",
        title: "How would you like to receive notifications?",
        'type: 1,
        options: [allNotificationsOption, importantOnlyOption],
        singleSelect: true,
        required: true,
        inOnboarding: true
    };

    // Create the update request with new onboarding configuration
    discord:UpdateGuildOnboardingRequest updateRequest = {
        prompts: [interestsPrompt, notificationsPrompt],
        defaultChannelIds: [welcomeChannelId, rulesChannelId, generalChannelId, introductionsChannelId],
        enabled: true
    };

    // Update the guild onboarding settings
    discord:GuildOnboardingResponse updatedOnboarding = check discordClient->/guilds/[guildId]/onboarding.put(updateRequest);

    io:println("Onboarding configuration updated successfully!");
    io:println("\nUpdated Onboarding Configuration:");
    io:println("  - Guild ID: " + updatedOnboarding.guildId);
    io:println("  - Enabled: " + updatedOnboarding.enabled.toString());
    io:println("  - Number of prompts: " + updatedOnboarding.prompts.length().toString());
    io:println("  - Default channels: " + updatedOnboarding.defaultChannelIds.length().toString());

    // Display the configured prompts
    io:println("\nConfigured Onboarding Prompts:");
    foreach discord:OnboardingPromptResponse prompt in updatedOnboarding.prompts {
        io:println("  Prompt: " + prompt.title);
        io:println("    - Type: " + prompt.'type.toString());
        io:println("    - Required: " + prompt.required.toString());
        io:println("    - Single Select: " + prompt.singleSelect.toString());
        io:println("    - In Onboarding: " + prompt.inOnboarding.toString());
        io:println("    - Options count: " + prompt.options.length().toString());
        
        foreach discord:OnboardingPromptOptionResponse option in prompt.options {
            io:println("      * " + option.title + ": " + option.description);
        }
    }

    // Display default channels
    io:println("\nDefault Channels for New Members:");
    foreach string channelId in updatedOnboarding.defaultChannelIds {
        io:println("  - Channel ID: " + channelId);
    }

    io:println("\n=== Guild Onboarding Configuration Complete ===");
    io:println("New members will now see the configured onboarding prompts and be added to default channels.");
}