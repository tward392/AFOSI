function hideStatusBar()
{
 document.getElementById("maxbuttononly").style.display="inline";
 document.getElementById("footpanel").style.display="none";
 document.getElementById("minbuttononly").style.display="none";
}

function showStatusBar()
{
 document.getElementById("maxbuttononly").style.display="none";
 document.getElementById("footpanel").style.display="inline";
 document.getElementById("minbuttononly").style.display="inline";
}

function getStatusBar(pObjSid)
{
	var get = new htmldb_Get(null,
			    $v('pFlowId'),
			    'APPLICATION_PROCESS=getStatusBar',
			    $v('pFlowStepId'));  

	get.addParam('x01',pObjSid);
	gReturn = get.get();
	return gReturn;
}
