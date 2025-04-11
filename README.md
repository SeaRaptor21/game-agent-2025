# Game Agent
**NMS Blue B-14 2025**

## Game Description
Downburst is a fast-paced puzzle game, where the player must navigate a tall vertical level and reach a goal at the bottom, without hitting any spikes. Fans are also present, which produce wind that can push the player in a certain direction, disabling normal movement. This game fits the theme of “physics in motion” because the player is always constantly moving, and is acted upon by several forces: gravity, player movement, and possibly wind.

## Languages and Libraries Used
Most of this game and the accompanying Q-Learning agent is programmed in GDScript, with just a small utility script written in Python to produce the possible sets of moves for the agent to take (essentially just not letting it run into walls). All of the integral processing and calculations are done in GDScript as the game is running. No external libraries were used, apart from any libraries included in a default install of Godot 4.3.stable.

## Development Process
To start, we began brainstorming ideas about physics games that could also be as discrete as possible to allow the easy implementation of an RL agent. To maximize discreteness, we went to Tetris, which is played on a very basic grid and with only a few possible moves. One thing led to another, and we began development on Downburst with a fairly open mind. We set up a GitHub repository to ease sharing and development, and we got to work. For testing, we largely reached out to family members to see their general impression of the game, as well as what they thought we should change.

To design the Q-Learning agent, we first went to the links included in the Game Agent website, then adapted this code to work in GDScript, as well as placing it inside of a class. From here, design and training was fairly straightforward, with deciding what should be rewarded or discouraged and playing around with key factors such as the learning rate (alpha) and exploration factor (epsilon). We found that most of the time, the agent could perform flawlessly with 1000 episodes of training, so this is what we used as a default in the training splash screen.

## AI Tools
We briefly used ChatGPT to help brainstorm and design the game, and attempted to use it for level design (which didn’t work very well), but otherwise mostly developed the game completely without the assistance of any AI or LLM. As for tutoring on RL theory, we mostly used ChatGPT as a starting point for finding places to research about the topic.
