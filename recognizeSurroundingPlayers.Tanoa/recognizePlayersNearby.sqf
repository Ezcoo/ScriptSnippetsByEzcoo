EZ_fnc_debug_allUnitsWTS = {
    {
        worldToScreen getPos _x
    } forEach allUnits - entities "HeadlessClient_F";
};

EZ_fnc_debug_distanceToUnits = {
    private _distanceToUnits = [];

    {
        _distanceToUnits pushBack (player distance _x)
    } forEach allUnits - entities "HeadlessClient_F";

    _distanceToUnits;
};

KK_fnc_trueZoom = {
    // Function by Killzone Kid
    (
        [0.5,0.5] 
        distance2D  
        worldToScreen 
        positionCameraToWorld 
        [0,3,4]
    ) * (
        getResolution 
        select 5
    ) / 2
};

EZ_fnc_playersInRange = {
    if (EZ_var_frameNumber > 0) then {
        deleteMarker "playersRecognizedInArea";
    };

    private _playersRecognizedInRadius = call KK_fnc_trueZoom * 60;

    private _playersRecognizedInArea = createMarkerLocal ["playersRecognizedInArea", getPos player];
    _playersRecognizedInArea setMarkerText "";
    _playersRecognizedInArea setMarkerSize [_playersRecognizedInRadius, _playersRecognizedInRadius];
    _playersRecognizedInArea setMarkerDir 0;
    _playersRecognizedInArea setMarkerShape "ELLIPSE";

    private _players = allUnits; // just for testing, for production use this instead: allPlayers - entities "HeadlessClient_F"; or allUnits - entities "HeadlessClient_F";
    private _playersInRange = _players inAreaArray _playersRecognizedInArea;

    _playersInRange;
};

EZ_fnc_visiblePlayers = {
    private _playersInRange = call EZ_fnc_playersInRange;
    private _visiblePlayers = [];

    {
        if (!(lineIntersects [eyePos player, eyePos _x, vehicle player, vehicle _x])) then {
            _visiblePlayers pushBack _x;
        };
    } forEach _playersInRange;

    _visiblePlayers;
};

EZ_fnc_getTextSize = {
    private _target = _this;

    private _distance = player distance _target;
    private _zoom = call KK_fnc_trueZoom;

    private _unitSize = (_distance / _zoom);

    private _textSize = (-(_unitSize / 20) + (_unitsize * 0.025) + 2.5) * 0.02 / (getResolution select 5);

    if (_textSize > 0.05) then {
        _textSize = 0.05;
    };

    if (_textSize < 0.02) then {
        _textSize = 0.02;
    };

    _textSize;
};

EZ_fnc_getTextAlpha = {
    private _target = _this;

    private _zoom = call KK_fnc_trueZoom;
    private _distance = player distance _target;

    private _alpha = 0;

    if ((_distance / _zoom) < 60) then {
        _alpha = -(_distance / _zoom / 30) + 2;
    };

    if (_alpha < 0) then {
        _alpha = 0;
    };

    if (_alpha > 1) then {
        _alpha = 1;
    };

    _alpha;
};

EZ_fnc_drawTextPlayer = {
    private _visiblePlayers = call EZ_fnc_visiblePlayers;

    {
        drawIcon3D ["", [0,0.8,0,_x call EZ_fnc_getTextAlpha], ASLToAGL getPosASL _x, 0, 0, 0, "Target", 2, _x call EZ_fnc_getTextSize, "PuristaMedium"];
    } forEach _visiblePlayers;

    count _visiblePlayers;
};
