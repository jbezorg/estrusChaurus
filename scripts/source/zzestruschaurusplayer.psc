Scriptname zzEstrusChaurusPlayer extends ReferenceAlias  

event OnPlayerLoadGame()
	Quest me = self.GetOwningQuest()

	( me as zzEstrusChaurusMCMScript ).registerMenus()
endEvent

event OnCellLoad()
	Quest me = self.GetOwningQuest()

	if ( me as zzEstrusChaurusMCMScript ).bRegisterCompanions
		( me as zzEstrusChaurusAE ).AddCompanions()
	endIf
endEvent
