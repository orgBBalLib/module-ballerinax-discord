import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string discordBotToken = ?;
configurable string guildId = ?;

// Sample channel and role IDs for onboarding configuration
configurable string welcomeChannelId = ?;
configurable string rulesChannelId = ?;
configurable string generalChannelId = ?;
configurable string memberRoleId = ?;
configurable string gamerRoleId = ?;
configurable string developerRoleId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: discordBotToken
        }
    });

    io:println("=== Discord Guild Onboarding Configuration ===\n");

    // Step 1: Retrieve current onboarding settings to understand existing configuration
    io:println("Step 1: Fetching current onboarding settings...");
    discord:UserGuildOnboardingResponse currentOnboarding = check discordClient->/guilds/[guildId]/onboarding();
    
    io:println("Current Onboarding Configuration:");
    io:println("  - Guild ID: " + currentOnboarding.guildId);
    io:println("  - Enabled: " + currentOnboarding.enabled.toString());
    io:println("  - Default Channels: " + currentOnboarding.defaultChannelIds.length().toString());
    io:println("  - Prompts Configured: " + currentOnboarding.prompts.length().toString());
    
    // Display existing prompts if any
    if currentOnboarding.prompts.length() > 0 {
        io:println("\n  Existing Prompts:");
        foreach discord:OnboardingPromptResponse promptItem in currentOnboarding.prompts {
            io:println("    - " + promptItem.title + " (Required: " + promptItem.required.toString() + ")");
        }
    }

    // Step 2: Prepare and update the onboarding configuration with new welcome prompts
    io:println("\nStep 2: Configuring new onboarding experience...");

    // Create onboarding prompt options for role selection
    discord:OnboardingPromptOptionRequest gamerOption = {
        title: "Gamer",
        description: "I'm here to find gaming buddies and discuss games!",
        roleIds: [gamerRoleId],
        channelIds: [],
        emojiName: "🎮"
    };

    discord:OnboardingPromptOptionRequest developerOption = {
        title: "Developer",
        description: "I'm interested in coding and tech discussions!",
        roleIds: [developerRoleId],
        channelIds: [],
        emojiName: "💻"
    };

    discord:OnboardingPromptOptionRequest casualOption = {
        title: "Casual Member",
        description: "Just here to hang out and chat!",
        roleIds: [memberRoleId],
        channelIds: [],
        emojiName: "👋"
    };

    // Create the interest selection prompt using UpdateOnboardingPromptRequest
    discord:UpdateOnboardingPromptRequest interestPrompt = {
        id: "0",
        title: "What brings you to our community?",
        'type: 0,
        options: [gamerOption, developerOption, casualOption],
        singleSelect: false,
        required: true,
        inOnboarding: true
    };

    // Create channel selection options
    discord:OnboardingPromptOptionRequest generalChannelOption = {
        title: "General Chat",
        description: "Our main community hangout space",
        channelIds: [generalChannelId],
        roleIds: [],
        emojiName: "💬"
    };

    discord:OnboardingPromptOptionRequest rulesChannelOption = {
        title: "Rules & Guidelines",
        description: "Important community rules to know",
        channelIds: [rulesChannelId],
        roleIds: [],
        emojiName: "📜"
    };

    // Create the channel selection prompt using UpdateOnboardingPromptRequest
    discord:UpdateOnboardingPromptRequest channelPrompt = {
        id: "1",
        title: "Which channels would you like to see?",
        'type: 1,
        options: [generalChannelOption, rulesChannelOption],
        singleSelect: false,
        required: false,
        inOnboarding: true
    };

    // Create the prompts array with the correct type
    discord:UpdateOnboardingPromptRequest[] promptsArray = [interestPrompt, channelPrompt];

    // Prepare the complete onboarding update request
    discord:UpdateGuildOnboardingRequest onboardingUpdate = {
        enabled: true,
        defaultChannelIds: [welcomeChannelId, rulesChannelId, generalChannelId],
        prompts: promptsArray,
        mode: 1
    };

    // Step 3: Apply the new onboarding configuration
    io:println("Step 3: Applying new onboarding configuration...");
    discord:GuildOnboardingResponse updatedOnboarding = check discordClient->/guilds/[guildId]/onboarding.put(onboardingUpdate);

    io:println("\n=== Onboarding Configuration Updated Successfully ===");
    io:println("Updated Configuration Details:");
    io:println("  - Guild ID: " + updatedOnboarding.guildId);
    io:println("  - Enabled: " + updatedOnboarding.enabled.toString());
    io:println("  - Default Channels Count: " + updatedOnboarding.defaultChannelIds.length().toString());
    io:println("  - Total Prompts: " + updatedOnboarding.prompts.length().toString());

    // Display the configured prompts
    io:println("\nConfigured Onboarding Prompts:");
    foreach discord:OnboardingPromptResponse promptEntry in updatedOnboarding.prompts {
        io:println("  Prompt: " + promptEntry.title);
        int promptTypeValue = promptEntry.'type;
        string promptTypeStr = promptTypeValue == 0 ? "Multiple Choice" : "Dropdown";
        io:println("    - Type: " + promptTypeStr);
        io:println("    - Required: " + promptEntry.required.toString());
        io:println("    - Single Select: " + promptEntry.singleSelect.toString());
        io:println("    - Options: " + promptEntry.options.length().toString());
        foreach discord:OnboardingPromptOptionResponse optionItem in promptEntry.options {
            io:println("      * " + optionItem.title + ": " + optionItem.description);
        }
    }

    io:println("\n=== Guild Onboarding Setup Complete ===");
    io:println("New members will now see the configured onboarding flow when joining your server!");
}