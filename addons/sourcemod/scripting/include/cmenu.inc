/*
* 
* INCLUCE FOR THE SOURCEMOD PLUGIN; WARDEN MENU
* https://forums.alliedmods.net/showthread.php?t=298907
* 
*/
#if defined cmenuincluded
 #endinput
#endif
#define cmenuincluded

/**
* Called when client opens the menu.
*
* @param     client index
*/
forward void OnCMenuOpened(int param);

/**
* Called when an event day is created.
*/
forward void OnEventDayCreated();

/**
* Called when an event day is aborted.
*/
forward void OnEventDayAborted();

/**
* Called when Hide n' Seek is over
*/
forward void OnHnsOver();

/**
* Check if there is a event day currently active.
* 
* @return     true if yes
*/
native bool IsEventDayActive();

/**
* Check if a Hide and Seek game is running.
*
* @return     true if yes
*/
native bool IsHnsActive();

/**
* Check if a Gravity Freeday is running.
*
* @return     true if yes
*/
native bool IsGravFreedayActive();

/**
* Check if a warday is running.
*
* @return     true if yes
*/
native bool IsWarActive();

/**
* Check if a freeday is running.
*
* @return     true if yes
*/
native bool IsFreedayActive();

/**
* Check if the specified client already has a freeday.
*
* @param     client index
* @return     true if yes
*/
native bool ClientHasFreeday(int client);

/**
* Give a client a freeday
*
* @param      client index
* @return     true if successful
*/
native bool GiveClientFreeday(int client);

/*
* Remove a client's freeday
*
* @param      client index
* @return     true if successful
*/
native bool RemoveClientFreeday(int client);