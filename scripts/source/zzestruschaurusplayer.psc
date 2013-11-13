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

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	;Debug.Trace( "================================================================================="  )
	;Debug.Trace( "MODNAME TEST: " + Game.GetModName( Math.RightShift( akBaseItem.GetFormID(), 24 ) )  )
	;Debug.Trace( "================================================================================="  )
endEvent
