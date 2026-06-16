import ballerina/io;
import ballerinax/discord;

// Configurable variables for Discord bot authentication
configurable string botToken = ?;
configurable string guildId = ?;

// Sample channel and role IDs for onboarding configuration
configurable string welcomeChannelId = ?;
configurable string rulesChannelId = ?;
configurable string generalChannelId = ?;
configurable string memberRoleId = ?;
configurable string gamingRoleId = ?;
configurable string artRoleId = ?;

public function main() returns error? {
    // Initialize the Discord client with bot token authentication
    discord:Client discordClient = check new ({
        auth: {
            authorization: botToken
        }
    });

    io:println("=== Discord Guild Onboarding Setup ===\n");

    // Step 1: Fetch the current onboarding configuration to understand existing settings
    io:println("Step 1: Fetching current onboarding configuration...");
    discord:UserGuildOnboardingResponse currentOnboarding = check discordClient->/guilds/[guildId]/onboarding();
    
    io:println("Current Onboarding Status:");
    io:println("  - Enabled: ", currentOnboarding.enabled);
    io:println("  - Guild ID: ", currentOnboarding.guildId);
    io:println("  - Default Channels: ", currentOnboarding.defaultChannelIds.length(), " configured");
    io:println("  - Prompts: ", currentOnboarding.prompts.length(), " configured\n");

    // Display existing prompts if any
    if currentOnboarding.prompts.length() > 0 {
        io:println("Existing Prompts:");
        foreach discord:OnboardingPromptResponse prompt in currentOnboarding.prompts {
            io:println("  - ", prompt.title, " (Options: ", prompt.options.length(), ")");
        }
        io:println();
    }

    // Step 2: Prepare the updated onboarding configuration with customized settings
    io:println("Step 2: Preparing updated onboarding configuration...");

    // Create welcome prompt options for introducing new members to the community
    discord:OnboardingPromptOptionRequest welcomeOption1 = {
        title: "I've read and agree to the rules",
        description: "Acknowledge that you've read our community guidelines",
        channelIds: [rulesChannelId],
        roleIds: [memberRoleId],
        emojiName: "✅"
    };

    discord:OnboardingPromptOptionRequest welcomeOption2 = {
        title: "Show me around",
        description: "Get a tour of our community channels",
        channelIds: [welcomeChannelId, generalChannelId],
        roleIds: [memberRoleId],
        emojiName: "👋"
    };

    // Create interest-based prompt options for role selection
    discord:OnboardingPromptOptionRequest interestOption1 = {
        title: "Gaming",
        description: "I'm interested in gaming discussions and events",
        channelIds: [],
        roleIds: [gamingRoleId],
        emojiName: "🎮"
    };

    discord:OnboardingPromptOptionRequest interestOption2 = {
        title: "Art & Creative",
        description: "I'm interested in art, design, and creative content",
        channelIds: [],
        roleIds: [artRoleId],
        emojiName: "🎨"
    };

    // Create onboarding prompts using the correct type with required 'id' field
    // Using empty string for id to indicate new prompt creation
    discord:UpdateOnboardingPromptRequest welcomePrompt = {
        id: "",
        title: "Welcome to our community!",
        'type: 0,
        singleSelect: true,
        required: true,
        inOnboarding: true,
        options: [welcomeOption1, welcomeOption2]
    };

    discord:UpdateOnboardingPromptRequest interestPrompt = {
        id: "",
        title: "What are you interested in?",
        'type: 0,
        singleSelect: false,
        required: false,
        inOnboarding: true,
        options: [interestOption1, interestOption2]
    };

    // Build the complete onboarding update request
    discord:UpdateOnboardingPromptRequest[] promptsArray = [welcomePrompt, interestPrompt];
    
    discord:UpdateGuildOnboardingRequest onboardingUpdate = {
        enabled: true,
        defaultChannelIds: [welcomeChannelId, rulesChannelId, generalChannelId],
        prompts: promptsArray,
        mode: 0
    };

    io:println("Configuration prepared with:");
    io:println("  - 3 default channels for new members");
    io:println("  - 2 onboarding prompts (Welcome + Interests)");
    io:println("  - Role assignments for community integration\n");

    // Step 3: Update the guild onboarding configuration
    io:println("Step 3: Updating guild onboarding configuration...");
    discord:GuildOnboardingResponse updatedOnboarding = check discordClient->/guilds/[guildId]/onboarding.put(onboardingUpdate);

    io:println("\n=== Onboarding Update Successful! ===");
    io:println("Updated Configuration:");
    io:println("  - Guild ID: ", updatedOnboarding.guildId);
    io:println("  - Enabled: ", updatedOnboarding.enabled);
    io:println("  - Default Channels: ", updatedOnboarding.defaultChannelIds.length());
    io:println("  - Prompts Configured: ", updatedOnboarding.prompts.length());

    // Display the configured prompts
    io:println("\nConfigured Onboarding Prompts:");
    foreach discord:OnboardingPromptResponse prompt in updatedOnboarding.prompts {
        io:println("  📋 ", prompt.title);
        string promptTypeLabel = prompt.'type == 0 ? "Multiple Choice" : "Dropdown";
        io:println("     - Type: ", promptTypeLabel);
        io:println("     - Required: ", prompt.required);
        io:println("     - Single Select: ", prompt.singleSelect);
        io:println("     - Options:");
        foreach discord:OnboardingPromptOptionResponse option in prompt.options {
            io:println("       • ", option.title, " - ", option.description);
        }
    }

    io:println("\n✅ Guild onboarding setup completed successfully!");
    io:println("New members will now see the customized onboarding flow when joining the server.");
}