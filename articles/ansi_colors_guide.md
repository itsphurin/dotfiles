# ANSI Escape Code Guide for Terminal Colors

This guide explains how to use ANSI Escape Codes to display colors in terminals, consoles, or command lines.

## About ANSI Escape Codes

ANSI Escape Codes are special sequences used to control terminal display, particularly for text formatting such as colors, bold text, underlines, etc. These codes start with an Escape character (`\033`, `\e`, `\x1b`, or `\u001b`) followed by an opening bracket `[` and numeric codes.

## Basic Format

```
\x1b[<CODE>m
```

or

```
\u001b[<CODE>m
```

Where `<CODE>` is a numeric code that defines the color or style.

## Color Codes

### Foreground Colors (Text Colors)

| Code | Color   | Example                       | Preview                                         |
| ---- | ------- | ----------------------------- | ----------------------------------------------- |
| `30` | Black   | `\x1b[30mBlack text\x1b[0m`   | <span style="color:black">Black text</span>     |
| `31` | Red     | `\x1b[31mRed text\x1b[0m`     | <span style="color:red">Red text</span>         |
| `32` | Green   | `\x1b[32mGreen text\x1b[0m`   | <span style="color:green">Green text</span>     |
| `33` | Yellow  | `\x1b[33mYellow text\x1b[0m`  | <span style="color:yellow">Yellow text</span>   |
| `34` | Blue    | `\x1b[34mBlue text\x1b[0m`    | <span style="color:blue">Blue text</span>       |
| `35` | Magenta | `\x1b[35mMagenta text\x1b[0m` | <span style="color:magenta">Magenta text</span> |
| `36` | Cyan    | `\x1b[36mCyan text\x1b[0m`    | <span style="color:cyan">Cyan text</span>       |
| `37` | White   | `\x1b[37mWhite text\x1b[0m`   | <span style="color:white">White text</span>     |

### Bright Foreground Colors

| Code | Color               | Example                              | Preview                                                                                         |
| ---- | ------------------- | ------------------------------------ | ----------------------------------------------------------------------------------------------- |
| `90` | Bright Black (Gray) | `\x1b[90mGray text\x1b[0m`           | <span style="color:gray">Gray text</span>                                                       |
| `91` | Bright Red          | `\x1b[91mBright red text\x1b[0m`     | <span style="color:#ff3333">Bright red text</span>                                              |
| `92` | Bright Green        | `\x1b[92mBright green text\x1b[0m`   | <span style="color:#33ff33">Bright green text</span>                                            |
| `93` | Bright Yellow       | `\x1b[93mBright yellow text\x1b[0m`  | <span style="color:#ffff33">Bright yellow text</span>                                           |
| `94` | Bright Blue         | `\x1b[94mBright blue text\x1b[0m`    | <span style="color:#3333ff">Bright blue text</span>                                             |
| `95` | Bright Magenta      | `\x1b[95mBright magenta text\x1b[0m` | <span style="color:#ff33ff">Bright magenta text</span>                                          |
| `96` | Bright Cyan         | `\x1b[96mBright cyan text\x1b[0m`    | <span style="color:#33ffff">Bright cyan text</span>                                             |
| `97` | Bright White        | `\x1b[97mBright white text\x1b[0m`   | <span style="color:#ffffff; text-shadow: 0px 0px 1px rgba(0,0,0,0.5);">Bright white text</span> |

### Background Colors

| Code | Color              | Example                             | Preview                                                                       |
| ---- | ------------------ | ----------------------------------- | ----------------------------------------------------------------------------- |
| `40` | Black Background   | `\x1b[40mBlack background\x1b[0m`   | <span style="background-color:black; color:white">Black background</span>     |
| `41` | Red Background     | `\x1b[41mRed background\x1b[0m`     | <span style="background-color:red; color:white">Red background</span>         |
| `42` | Green Background   | `\x1b[42mGreen background\x1b[0m`   | <span style="background-color:green; color:white">Green background</span>     |
| `43` | Yellow Background  | `\x1b[43mYellow background\x1b[0m`  | <span style="background-color:yellow; color:black">Yellow background</span>   |
| `44` | Blue Background    | `\x1b[44mBlue background\x1b[0m`    | <span style="background-color:blue; color:white">Blue background</span>       |
| `45` | Magenta Background | `\x1b[45mMagenta background\x1b[0m` | <span style="background-color:magenta; color:white">Magenta background</span> |
| `46` | Cyan Background    | `\x1b[46mCyan background\x1b[0m`    | <span style="background-color:cyan; color:black">Cyan background</span>       |
| `47` | White Background   | `\x1b[47mWhite background\x1b[0m`   | <span style="background-color:white; color:black">White background</span>     |

### Bright Background Colors

| Code  | Color                     | Example                                     | Preview                                                                              |
| ----- | ------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------ |
| `100` | Bright Black Background   | `\x1b[100mBright Black background\x1b[0m`   | <span style="background-color:#333333; color:white">Bright Black background</span>   |
| `101` | Bright Red Background     | `\x1b[101mBright Red background\x1b[0m`     | <span style="background-color:#ff3333; color:white">Bright Red background</span>     |
| `102` | Bright Green Background   | `\x1b[102mBright Green background\x1b[0m`   | <span style="background-color:#33ff33; color:black">Bright Green background</span>   |
| `103` | Bright Yellow Background  | `\x1b[103mBright Yellow background\x1b[0m`  | <span style="background-color:#ffff33; color:black">Bright Yellow background</span>  |
| `104` | Bright Blue Background    | `\x1b[104mBright Blue background\x1b[0m`    | <span style="background-color:#3333ff; color:white">Bright Blue background</span>    |
| `105` | Bright Magenta Background | `\x1b[105mBright Magenta background\x1b[0m` | <span style="background-color:#ff33ff; color:white">Bright Magenta background</span> |
| `106` | Bright Cyan Background    | `\x1b[106mBright Cyan background\x1b[0m`    | <span style="background-color:#33ffff; color:black">Bright Cyan background</span>    |
| `107` | Bright White Background   | `\x1b[107mBright White background\x1b[0m`   | <span style="background-color:#ffffff; color:black">Bright White background</span>   |

## Text Styles

| Code | Style         | Example                            | Note                             | Preview                                                                |
| ---- | ------------- | ---------------------------------- | -------------------------------- | ---------------------------------------------------------------------- |
| `0`  | Reset         | `\x1b[0m`                          | Resets all styles to default     | Normal text                                                            |
| `1`  | Bold          | `\x1b[1mBold text\x1b[0m`          |                                  | <span style="font-weight:bold">Bold text</span>                        |
| `2`  | Dim           | `\x1b[2mDim text\x1b[0m`           | Not supported in all terminals   | <span style="opacity:0.7">Dim text</span>                              |
| `3`  | Italic        | `\x1b[3mItalic text\x1b[0m`        | Not supported in all terminals   | <span style="font-style:italic">Italic text</span>                     |
| `4`  | Underline     | `\x1b[4mUnderlined text\x1b[0m`    |                                  | <span style="text-decoration:underline">Underlined text</span>         |
| `5`  | Blink         | `\x1b[5mBlinking text\x1b[0m`      | Not supported in all terminals   | <span style="animation: blink 1s linear infinite">Blinking text</span> |
| `7`  | Inverse       | `\x1b[7mInverted text\x1b[0m`      | Swaps text and background colors | <span style="background-color:black; color:white">Inverted text</span> |
| `8`  | Hidden        | `\x1b[8mHidden text\x1b[0m`        | Makes text invisible             | <span style="opacity:0">Hidden text</span>                             |
| `9`  | Strikethrough | `\x1b[9mStrikethrough text\x1b[0m` | Not supported in all terminals   | <span style="text-decoration:line-through">Strikethrough text</span>   |

<style>
@keyframes blink {
  50% { opacity: 0; }
}
</style>

## Using Multiple Codes Together

You can combine multiple codes by separating them with semicolons `;`

```
\x1b[<CODE1>;<CODE2>;<CODE3>m
```

Example: Bold red underlined text

```
\x1b[31;1;4mBold red underlined text\x1b[0m
```

## Usage Examples in JavaScript

```javascript
// Function to colorize text
function colorize(text, colorCode) {
  return `\x1b[${colorCode}m${text}\x1b[0m`;
}

// Usage examples
console.log(colorize("Red text", 31));
console.log(colorize("Green text", 32));
console.log(colorize("Yellow text", 33));

// Bold cyan text
console.log(`\x1b[1;36mBold cyan text\x1b[0m`);

// White text on red background
console.log(`\x1b[37;41mWhite text on red background\x1b[0m`);
```

## Using in npm scripts

```json
{
  "scripts": {
    "start": "echo \"\\033[32mStarting server...\\033[0m\" && node server.js",
    "build": "echo \"\\033[33mBuilding project...\\033[0m\" && webpack",
    "test": "echo \"\\033[36mRunning tests...\\033[0m\" && jest",
    "error-demo": "echo \"\\033[31;1mError occurred!\\033[0m\""
  }
}
```

## Simple Logger Example in Node.js

```javascript
// logger.js
const logger = {
  info: (message) => {
    console.log(`\x1b[34m[INFO]\x1b[0m ${message}`);
  },
  success: (message) => {
    console.log(`\x1b[32m[SUCCESS]\x1b[0m ${message}`);
  },
  warning: (message) => {
    console.log(`\x1b[33m[WARNING]\x1b[0m ${message}`);
  },
  error: (message) => {
    console.log(`\x1b[31m[ERROR]\x1b[0m ${message}`);
  },
  debug: (message) => {
    console.log(`\x1b[90m[DEBUG]\x1b[0m ${message}`);
  },
};

module.exports = logger;
```

## Log Severity Color Schemes

Using colors for different log severity levels is a common practice to make log messages more readable. Here are recommended color schemes for different severity levels:

| Severity Level | Description                                  | ANSI Code       | Example                                                   | Preview                                                                                                         |
| -------------- | -------------------------------------------- | --------------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `FATAL`        | Critical errors causing application to abort | `\x1b[1;37;41m` | `\x1b[1;37;41m[FATAL]\x1b[0m Database connection failed`  | <span style="background-color:#ff0000; color:white; font-weight:bold">[FATAL]</span> Database connection failed |
| `ERROR`        | Error conditions                             | `\x1b[1;31m`    | `\x1b[1;31m[ERROR]\x1b[0m Failed to process request`      | <span style="color:#ff0000; font-weight:bold">[ERROR]</span> Failed to process request                          |
| `WARNING`      | Warning conditions                           | `\x1b[1;33m`    | `\x1b[1;33m[WARNING]\x1b[0m Configuration file not found` | <span style="color:#ffcc00; font-weight:bold">[WARNING]</span> Configuration file not found                     |
| `INFO`         | Informational messages                       | `\x1b[1;34m`    | `\x1b[1;34m[INFO]\x1b[0m Server started on port 3000`     | <span style="color:#0099ff; font-weight:bold">[INFO]</span> Server started on port 3000                         |
| `DEBUG`        | Debug-level messages                         | `\x1b[1;36m`    | `\x1b[1;36m[DEBUG]\x1b[0m Connecting to database`         | <span style="color:#00cccc; font-weight:bold">[DEBUG]</span> Connecting to database                             |
| `TRACE`        | Detailed tracing information                 | `\x1b[1;90m`    | `\x1b[1;90m[TRACE]\x1b[0m Function called with params`    | <span style="color:#999999; font-weight:bold">[TRACE]</span> Function called with params                        |
| `SUCCESS`      | Success messages                             | `\x1b[1;32m`    | `\x1b[1;32m[SUCCESS]\x1b[0m Task completed`               | <span style="color:#00cc00; font-weight:bold">[SUCCESS]</span> Task completed                                   |

### Enhanced Logger Example with Severity Levels

```javascript
// enhanced-logger.js
const logger = {
  fatal: (message) => {
    console.log(`\x1b[1;37;41m[FATAL]\x1b[0m ${message}`);
  },
  error: (message) => {
    console.log(`\x1b[1;31m[ERROR]\x1b[0m ${message}`);
  },
  warning: (message) => {
    console.log(`\x1b[1;33m[WARNING]\x1b[0m ${message}`);
  },
  info: (message) => {
    console.log(`\x1b[1;34m[INFO]\x1b[0m ${message}`);
  },
  debug: (message) => {
    console.log(`\x1b[1;36m[DEBUG]\x1b[0m ${message}`);
  },
  trace: (message) => {
    console.log(`\x1b[1;90m[TRACE]\x1b[0m ${message}`);
  },
  success: (message) => {
    console.log(`\x1b[1;32m[SUCCESS]\x1b[0m ${message}`);
  },
};

// Example usage
logger.info("Application starting");
logger.debug("Loading configuration");
logger.warning("Cache not available");
logger.error("Could not connect to API");
logger.fatal("Database connection failed");
logger.trace("Function X called with params Y");
logger.success("User registration completed");

module.exports = logger;
```

## Shell Script Example

```bash
#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}Starting command...${RESET}"
echo -e "${GREEN}Operation completed successfully!${RESET}"
echo -e "${YELLOW}Warning: This file will be deleted in 7 days${RESET}"
echo -e "${RED}Error: File not found${RESET}"
```

## Working on Windows

Windows Command Prompt doesn't support ANSI Escape Codes by default. You need to:

1. Use PowerShell instead (supports ANSI colors)
2. Use Windows Terminal (supports ANSI colors)
3. Enable ANSI in Command Prompt by adding a registry key or using the command:

```batch
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1
```

## Important Notes

1. **Compatibility**: Some terminals may not support all escape codes
2. **Reset**: Always use `\x1b[0m` after colored text, otherwise the color might persist
3. **Complexity**: Many codes can make your code hard to read; consider using libraries like chalk for larger projects

## Alternatives

If you want an easier approach, you can use these libraries:

- **chalk** (JavaScript/Node.js): `npm install chalk`
- **colors.js** (JavaScript/Node.js): `npm install colors`
- **ansi-colors** (JavaScript/Node.js): `npm install ansi-colors`
- **colorama** (Python): `pip install colorama`
- **colored** (Rust): `cargo add colored`

## Additional Resources

- [Wikipedia: ANSI Escape Code](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [Bash tips: Colors and formatting](https://misc.flogisoft.com/bash/tip_colors_and_formatting)
- [Console Virtual Terminal Sequences (Microsoft)](https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences)

---

**Note**: This document was created to provide basic knowledge about ANSI Escape Codes for displaying colors in Terminals. Feel free to adapt it for your projects as needed.
