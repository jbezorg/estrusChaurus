Scriptname zzEstrusChaurusAnim extends sslAnimationFactory

function LoadAnimations()
	Debug.Notification("$EC_ANIM_CHECK");
	RegisterAnimation("EstrusTentacleDouble")
	RegisterAnimation("EstrusTentacleSide")
	RegisterAnimation("DwemerMachine")
endFunction

function EstrusTentacleDouble(string eventName, string id, float argNum, form sender)
	name = "Tentacle Double"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "zzEstrusTentacle01S1", 0)
	;AddPositionStage(a1, "zzEstrusTentacle01S2", 0)
	;AddPositionStage(a1, "zzEstrusTentacle01S3", 0)
	;AddPositionStage(a1, "zzEstrusTentacle01S4", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S41", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S42", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S43", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S5", 0)
	;AddPositionStage(a1, "zzEstrusTentacle01S6", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S61", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S62", 0)
	AddPositionStage(a1, "zzEstrusTentacle01S63", 0)
	AddPositionStage(a1, "zzEstrusCommon01Up", 0)
	AddPositionStage(a1, "zzEstrusCommon02Up", 0)
	AddPositionStage(a1, "zzEstrusCommon03Up", 0)
	AddPositionStage(a1, "zzEstrusCommon04Up", 0)
	AddPositionStage(a1, "zzEstrusGetUpFaceUp", 0)

	AddTag("Estrus")
	AddTag("Tentacle")
	AddTag("PCKnownAnim")

	Save()
endFunction

function EstrusTentacleSide(string eventName, string id, float argNum, form sender)
	name = "Tentacle Side"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "zzEstrusTentacle02S1", 0)
	;AddPositionStage(a1, "zzEstrusTentacle02S2", 0)
	;AddPositionStage(a1, "zzEstrusTentacle02S3", 0)
	;AddPositionStage(a1, "zzEstrusTentacle02S4", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S41", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S42", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S43", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S5", 0)
	;AddPositionStage(a1, "zzEstrusTentacle02S6", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S61", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S62", 0)
	AddPositionStage(a1, "zzEstrusTentacle02S63", 0)
	AddPositionStage(a1, "zzEstrusCommon01Down", 0)
	AddPositionStage(a1, "zzEstrusCommon02Down", 0)
	AddPositionStage(a1, "zzEstrusCommon03Down", 0)
	AddPositionStage(a1, "zzEstrusCommon04Down", 0)
	AddPositionStage(a1, "zzEstrusGetUpFaceDown", 0)

	AddTag("Estrus")
	AddTag("Tentacle")
	AddTag("PCKnownAnim")

	Save()
endFunction

function DwemerMachine(string eventName, string id, float argNum, form sender)
	name = "Dwemer Machine"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "zzEstrusMachine01S1", 0)
	;AddPositionStage(a1, "zzEstrusMachine01S2", 0)
	;AddPositionStage(a1, "zzEstrusMachine01S3", 0)
	;AddPositionStage(a1, "zzEstrusMachine01S4", 0)
	AddPositionStage(a1, "zzEstrusMachine01S41", 0)
	AddPositionStage(a1, "zzEstrusMachine01S42", 0)
	AddPositionStage(a1, "zzEstrusMachine01S43", 0)
	AddPositionStage(a1, "zzEstrusMachine01S5", 0)
	;AddPositionStage(a1, "zzEstrusMachine01S6", 0)
	AddPositionStage(a1, "zzEstrusMachine01S61", 0)
	AddPositionStage(a1, "zzEstrusMachine01S62", 0)
	AddPositionStage(a1, "zzEstrusMachine01S63", 0)
	AddPositionStage(a1, "zzEstrusCommon01Up", 0)
	AddPositionStage(a1, "zzEstrusCommon02Up", 0)
	AddPositionStage(a1, "zzEstrusCommon03Up", 0)
	AddPositionStage(a1, "zzEstrusCommon04Up", 0)
	AddPositionStage(a1, "zzEstrusGetUpFaceUp", 0)

	AddTag("Estrus")
	AddTag("Dwemer")
	AddTag("Machine")
	AddTag("PCKnownAnim")

	Save()
endFunction
