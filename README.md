# Reddit Trends Extension for Raycast

Browse trending posts from Reddit directly from Raycast.

![image](https://github.com/user-attachments/assets/862c26fd-af91-4521-bc7b-d485c7e8f74b)
![image](https://github.com/user-attachments/assets/6f76a865-7aab-4e01-8ae2-f050767aff46)

## Features

- View trending posts from any subreddit
- Search for specific subreddits directly from the search bar
- Filter posts by time range (today, week, month, year, all time)
- Open posts in browser
- Copy post links and titles to clipboard

## Installation

**Note**: This extension is currently under review and has not yet been accepted on the Raycast extension store.

### Prerequisites

- [Raycast](https://raycast.com) - Download and install if you haven't already

### Quick Install (Recommended)

**Step 1: Download the Extension**

Choose one of the following options:

- **Download ZIP**: [Download the latest release](https://github.com/yourusername/reddit-trends/archive/main.zip)
- **Clone repository**:
  ```bash
  git clone https://github.com/qusaismael/reddit-trends.git
  ```

**Step 2: Extract and Navigate**

If you downloaded the ZIP file, extract it to a safe location like `~/Documents/`. Then open Terminal and navigate to the project directory:

```bash
cd ~/Documents/reddit-trends-main
# or if you cloned:
cd reddit-trends
```

**Step 3: Run the Automated Install Script**

```bash
chmod +x install.sh
./install.sh
```

The script will automatically:
- Check if Raycast is installed
- Install Node.js (via Homebrew if available)
- Install Raycast CLI
- Install project dependencies
- Build the extension
- Import it into Raycast

**Step 4: Start Using**

1. Open Raycast (⌘ + Space)
2. Type "Reddit Trends" to start browsing
3. Configure preferences if needed (Extensions → Reddit Trends → Preferences)

### Manual Installation

If you prefer to install manually or the script doesn't work:

1. **Install Node.js**: Download from [nodejs.org](https://nodejs.org/) or via Homebrew: `brew install node`
2. **Install Raycast CLI**: `npm install -g @raycast/api@latest`
3. **Install dependencies**: `npm install`
4. **Build extension**: `npm run build`
5. **Import to Raycast**: `ray develop`

## Usage

1. Open the extension by typing "Reddit Trends" in Raycast
2. By default, it will show trending posts from r/popular
3. Use the search bar to view posts from a different subreddit
4. Use the dropdown menu to change the time range

## Preferences

- **Default Subreddit**: Set your preferred default subreddit (without the r/ prefix)
- **Time Range**: Choose the default time range for trending posts

## Development

```bash
# Start development mode (auto-reload on changes)
npm run dev

# Build for production
npm run build

# Re-import to Raycast after changes
ray develop

# Lint code
npm run lint

# Fix linting issues
npm run fix-lint
```

## Troubleshooting

If you encounter any issues during installation or usage, run the troubleshooting script:

```bash
chmod +x troubleshoot.sh
./troubleshoot.sh
```

This will check your system requirements, diagnose common issues, and provide solutions.

### Common Issues

- **Extension not appearing in Raycast**: Make sure Raycast is running and try restarting it
- **Command not found errors**: Ensure your PATH includes npm global bin directory
- **Permission errors**: Run `npm config set prefix ~/.npm-global` and update your PATH
- **Build failures**: Delete `node_modules` and run `npm install` again

## Uninstalling

To remove the extension:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

This will clean up build artifacts and provide instructions for removing the extension from Raycast.

## Tips

- Use the search bar to quickly switch between subreddits
- Press enter on a post to open it in your browser
- Use ⌘+K to see all available actions for a post
