// Shared code for all modes
untyped
globalize_all_functions


entity function GetProp(entity player)
{
    return player.p.currentPropEntity 
}

entity function GetRealProp(entity player) {
    return player.p.currentRealPropEntity
}

void function SetProp(entity player, entity prop)
{
    player.p.currentPropEntity = prop
}

void function SetRealProp(entity player, entity prop) {
    player.p.currentRealPropEntity = prop
}

asset function GetAsset(entity player) {
    return player.p.selectedProp.selectedAsset
}

asset function CastStringToAsset( string val ) {
    // pain
    // no way to do dynamic assets so 
	return expect asset ( compilestring( "return $\"" + val + "\"" )() )
}

float function round(float x) {
    return expect float( RoundToNearestInt(x) )
}

int function indexOf(array<asset> arr, asset val) {
    int idx = 0
    foreach(p in arr) {
        if (val == p) {
            return idx
        }
        idx++
    }
    return -1
}

string function serialize(string action, string ass, vector origin, vector angles) {
    string positionSerialized = origin.x.tostring() + "," + origin.y.tostring() + "," + origin.z.tostring()
	string anglesSerialized = angles.x.tostring() + "," + angles.y.tostring() + "," + angles.z.tostring()
    return "[" + action + "]" + ass + ";" + positionSerialized + ";" + anglesSerialized
}

string function SerializeVector( vector o ) {
    return o.x + "," + o.y + "," + o.z
}

string function SerializeProp( asset a, vector pos, vector ang, bool mantle, int fade) {
    return "0;" + string(a) + ";" + SerializeVector(pos) + ";" + SerializeVector(ang) + ";" + mantle + ";" + fade
}

string function SerializePropV2( asset a, vector pos, vector ang, bool hidden, int fade) {
    return "1;" + string(a) + ";" + SerializeVector(pos) + ";" + SerializeVector(ang) + ";" + hidden + ";" + fade
}

vector function DeserializeVector(string vec) {
    array<string> data = split(vec, ",")

    float x = data[0].tofloat()
    float y = data[1].tofloat()
    float z = data[2].tofloat()
    
    return < x, y, z >
}
#if SERVER
void function ClearPropMap() {
    int per = 5
    int i = 0

    foreach(prop in GetAllProps()) {
        i++
        prop.Destroy()

        if (i % per) {
            wait 0.1
        }
    }

    GetAllProps().clear()
}

string function CleanAsset(string a) {
    string r = a
    r = StringReplace(r, "$\"", "")
    r = StringReplace(r, "\"", "")
    return r
}

entity function DeserializeProp(string ss) {
    array<string> data = split(ss, ";")

    int ver = data[0].tointeger()
    asset model = CastStringToAsset(CleanAsset(data[1]))
    vector origin = DeserializeVector(data[2])
    vector angles = DeserializeVector(data[3])
    bool mantle = false
    bool hidden = false
    int fade = data[5].tointeger()

    if (data[4] == "true") {
        if (ver != 0) {
            hidden = true
        }
        mantle = true
    }

    entity e = CreatePropDynamicLightweight(model,origin,angles,SOLID_VPHYSICS,float(fade))
    e.SetScriptName("editor_placed_prop")
	if(mantle) e.AllowMantle()
    if(hidden) e.Hide()
	return e
}
#endif
TraceResults function GetPropLineTrace(entity player)
{
    TraceResults result = TraceLineHighDetail(player.EyePosition() + 5 * player.GetViewForward(), player.GetOrigin() + 1500 * player.GetViewForward(), [player], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_PLAYER)
    return result
}