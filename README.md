# Warden-Menu [![Build Status](https://travis-ci.org/condolent/Warden-Menu.svg?branch=dev)](https://travis-ci.org/condolent/Warden-Menu)
Sourcemod plugin for Jailbreak servers. Giving wardens a special menu to execute games with specific game-rules.

## Description
This plugin works great for jailbreak servers on CS:GO where the current warden can open up a menu. This menu gives the warden access to round-specific commands/variables that create funny games for all the players!

## Installation
Download and drop all the contents in /addons/sourcemod/ into your /csgo/addons/sourcemod/ folder.  
Type `sm plugins load cmenu` in the server console and you're done!

## Dependencies
This plugin currently only works with [ESK0s Jailbreak Warden](https://forums.alliedmods.net/showthread.php?t=278136) plugin.  
Make a request and I'll implement other warden plugins aswell.

## Features
The warden can create the following games for the round:

1. Hide and Seek
2. Freeday
3. Warday

## CVars
| ConVar      | Default | Description   |
|:----------- |:-------:|:------------- |
|`sm_cmenu_hns`|**1**|Add an option for Hide and Seek in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_hns_godmode`|**1**|Makes CT's invulnerable against attacks from T's during HnS to prevent rebels. 0 = Disable. 1 = Enable.|
|`sm_cmenu_hns_rounds`|**2**|How many times is HnS allowed per map? Set to 0 for unlimited.|
|`sm_cmenu_freeday`|**1**|Add an option for a freeday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_freeday_rounds`|**2**|How many times is a Freeday allowed per map? Set to 0 for unlimited.|
|`sm_cmenu_warday`|**1**|Add an option for Warday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_warday_rounds`|**2**|How many times is a Warday allowed per map?\nSet to 0 for unlimited.|

## Commands
| Command   | Description   | Flag     |
|:--------- |:------------- |:-------- |
|sm_cmenu   | _Opens up the warden menu._| - |
|sm_abortgames | _Cancels the current game._| b |

## Todo
_Currently in development, alot of stuff is in this list so it's currently unecessary to write everything down here!_

## Changelog
_None so far_
