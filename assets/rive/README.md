# Rive Character Animation Instructions

To create a Duolingo-style character animation for this app, follow these steps:

## Required Animations

Create a Rive file with the following animations:

1. **idle** - Default state, gentle breathing or blinking
2. **wave** - Friendly waving gesture (2 seconds)
3. **jump** - Excited jumping motion (600ms)
4. **celebrate** - Victory celebration with confetti or sparkles (3 seconds)
5. **think** - Thoughtful pose, maybe hand on chin (2 seconds)
6. **speak** - Mouth moving animation for when TTS is active

## Character Design Guidelines

- **Style**: Friendly, cartoon-like character similar to Duolingo's owl
- **Colors**: Use the app's color scheme (Green #58CC02, Blue #3371B9)
- **Size**: Design for 60x60px (header) and 190x190px (welcome screen)
- **Expressions**: Happy, encouraging, and educational

## Animation Guidelines

- **Smooth transitions** between states
- **Looping**: Only 'idle' and 'speak' should loop
- **Timing**: Match the durations specified in the code
- **Easing**: Use bounce/elastic easing for playful feel

## Export Settings

- Export as `.riv` file
- Name: `character_animations.riv`
- Place in: `assets/rive/`

## Fallback

If Rive animation fails to load, the app will fallback to the static character image at `assets/images/character.png`.