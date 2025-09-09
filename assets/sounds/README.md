# Sounds Directory

This directory should contain the following sound files for the Duolingo-style registration experience:

## Required Sound Files

### click.mp3
- Sound effect for button clicks and UI interactions
- Should be a short, pleasant click sound (around 0.1-0.2 seconds)
- Recommended: Light tap or button press sound

### success.mp3
- Sound effect for successful actions and celebrations
- Should be uplifting and positive (around 0.5-1 second)
- Recommended: Achievement chime or success fanfare

### error.mp3
- Sound effect for errors and validation failures
- Should be gentle but noticeable (around 0.3-0.5 seconds)
- Recommended: Soft error beep or notification sound

## Sound Format Requirements
- Format: MP3
- Sample Rate: 44.1 kHz
- Bit Rate: 128 kbps minimum
- Keep file sizes small for optimal app performance

## Usage
These sounds are used throughout the registration process to provide audio feedback:
- `click.mp3`: Button presses, form interactions
- `success.mp3`: Step completion, final registration success with confetti
- `error.mp3`: Form validation errors, registration failures

## Adding Sounds
1. Add your sound files to this directory
2. Ensure they follow the naming convention above
3. The app will automatically play them at appropriate times

## Fallback Behavior
If sound files are not found, the app will gracefully handle the error and continue without audio feedback.