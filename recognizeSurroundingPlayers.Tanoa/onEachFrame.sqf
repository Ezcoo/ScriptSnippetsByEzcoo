EZ_var_frameNumber = 0;

onEachFrame {


     hintSilent format [
        "CURRENT ZOOM: %1x, \n Units' position on screen: %2 \n Distance between all units and player: %3 \n Currently recognized units: %4 \n Targets nearby: %5 \n Player objNull: %6",
        round (call KK_fnc_trueZoom * 10) / 10, call EZ_fnc_debug_allUnitsWTS, call EZ_fnc_debug_distanceToUnits, call EZ_fnc_visiblePlayers, call EZ_fnc_drawTextPlayer, player == objNull
     ];

    EZ_var_frameNumber = EZ_var_frameNumber + 1;
};
