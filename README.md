
# Godot 4.3 Project - Highscore Connection Setup
**Ta följande med en nypa salt, det är ett game jam så jag är redo för fullt chaos! Men skrev ihop lite tillsammans med ai, kan vara bra för att få en överblick :D **

This project is a basic setup for a Godot 4.3 project, designed to connect to **Hyplays** server for highscore tracking. It also includes a basic structure for a game, with features such as volume control, a music player, and a start menu. 

## Features

- **Highscore system**: Connects to Hyplay's server to manage highscores.
- **Volume control**: Basic volume slider setup for managing audio levels.
- **Music player**: An in-game music player setup with control via a volume slider.
- **Start menu**: Basic start menu and scene management to navigate between game states.

## Prerequisites

Before you start contributing or testing, make sure you have the following installed:

- **Godot Engine 4.3**: This project is built with Godot 4.3. [Download it here](https://godotengine.org/download).
- **Python**: Required to run a local server for testing the highscore connection. [Download Python](https://www.python.org/downloads/).
- **Web Server**: To be able to test the highscore part of the project. The project needs to be hosted locally on `localhost:8080` for testing highscore functionality. You can use Python's built-in HTTP server for this.

\`\`\`bash
# Navigate to the folder where 'webpage_export' is located and run:
python3 -m http.server 8080
\`\`\`

## Setup

1. **Clone the repository**:
   \`\`\`bash
   git clone https://github.com/WilliamSundqvist/arcadegame.git
   cd arcadegame
   \`\`\`

2. **Open the project in Godot**:
   - Launch Godot 4.3.
   - Open the project by selecting the `project.godot` file located in the root directory of the project.

3. **Run the local web server for testing highscores**:
   - Ensure Python is installed.
   - Navigate to the `webpage_export` directory and run the following command:
     \`\`\`bash
     python3 -m http.server 8080
     \`\`\`
   - The project will now be accessible on `localhost:8080`.

4. **Test the highscore functionality**:
   -Start your browser and go to localhost:8080 and interact with the highscore system connected to the Hyplay server.
   - Ensure that the web server is running properly on the specified port.

## Project Structure

The project files are organized as follows:

Lets organise everything in folders, if we make a *enemy*, everything related to the enemy should be in a *enemy* folder.

This means that scenes, scripts and sprites/sound effects related to the enemy should be put in the same folder.

I also like **composition** instead of **inheritance** for godot. This is best explained in the following video: https://www.youtube.com/watch?v=74y6zWZfQKk
It's the way that Godot is set up, and therefor I find it the easiest way to create reusable components in the code.

## How to Contribute

1. **Fork the repository**.
2. **Create a branch** for your feature or bugfix:
   \`\`\`bash
   git checkout -b feature-name
   \`\`\`
3. **Make your changes** in Godot and/or GDScript files.
4. **Commit and push** your changes to your fork:
   \`\`\`bash
   git add .
   git commit -m "Added feature X"
   git push origin feature-name
   \`\`\`
5. **Create a pull request** on the main repository, detailing what changes you have made and why. (This step is not necessary let the chaos of pushing straight to main begin!)

### Coding Guidelines

- Follow the **Godot 4.3** GDScript conventions.
- Ensure all changes are tested and functional before submitting.
- Use descriptive names for variables and functions.


## Credits

- Project Lead: **[Your Name]**
- Contributors: List of contributors
- Highscore system powered by **Hyplay's free server**.
