# Claimmes Script for FiveM

This script provides a system where players can claim a knife on your FiveM server and reset it if needed, using the commands `/claimmes` and `/resetmes`. The script logs actions to Discord via webhooks and uses **ESX** for server integration and **OxMySQL** for database interaction.

## Features

1. **Claimmes (`/claimmes`)**

   * Players can claim the knife if they haven’t done so already.
   * When claimed, the player receives an item (`weapon_switchblade`) in their inventory.
   * The database is updated to track the knife claim status.
   * A Discord webhook logs the claim action.

2. **Resetmes (`/resetmes`)**

   * Only admins can reset a player’s claim status.
   * Resets the knife claim status to `FALSE` in the database.
   * A Discord webhook logs the reset action.

## Installation

### Requirements

* **ESX**: The script uses the ESX framework for player management.
* **OxMySQL**: The database is handled via OxMySQL.
* **Ox_Lib**: Used for player notifications via `ox_lib:notify`.
* **Discord Webhooks**: Webhooks for logging actions to Discord.

### Installation Steps

1. **Place the files in your resources folder**:

   * Ensure the files are in a folder inside your `resources` directory, e.g., `fusion-claimmes`.

2. **Add the script to your server configuration**:
   Add the following line to your `server.cfg`:

   ```bash
   ensure fusion-claimmes
   ```
