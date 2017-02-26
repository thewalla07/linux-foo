# Set of scripts that I use for my window manager herbstluftwm

## Time appropriate background images

### set-time-bg

This script gets the current time and calls the appropriate script (set-[noon|morning|evening|night]-bg) to set the background image using nitrogen. The time ranges are in hours (0-23). I have a cron job set up to call this script on startup and on the hour in order to have a wallpaper appropriate to the time of day set up.

The wallpapers I use are the Isle of Alps of the material islands collection which I purhcased from [artist Jenny Hanell's etsy store](https://www.etsy.com/people/hanelljenny). (not included in this repository)

## Spotify things

### playpause

Does what it says on the tin. I do not use this script as it is here, instead it is used in my keybindings in herbstluftwm/autostart, along with commands to go to the previous or next song in the queue.

### spotify-current

Gets the current track in the following format: Track - Artist

This is part of a program I intend to write to keep my current song displayed in my window manager.

### get_volume

Self explanatory, for display purposes in my window manager.
