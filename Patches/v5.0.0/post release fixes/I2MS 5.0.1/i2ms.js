htmldb_delete_message = "Are you sure?";
var apex_app;
var apex_session;
var apex_debug;
var isPopup;

function setGlobals(pAppId,pSession,pDebug){
	apex_app = pAppId;
	apex_session = pSession;
	apex_debug = pDebug;
	isPopup = false;
}

function logInfo(pMsg){
   var get = new htmldb_Get(null,
                            $v('pFlowId'),
                            'APPLICATION_PROCESS=Log_Info',
                            $v('pFlowStepId'));
   get.addParam('x01',pMsg);
   gReturn = get.get();
}

/*
 * Helper function for the export to CSV functions below. Given an html element it traverses the
 * parent elements looking for a node with the given pRegionClass name and a first child with the given
 * pTitleClass name.
 */
function getTitleNode(pRegionClass, pTitleClass, pStartNode){
  var clsRegion = new RegExp(pRegionClass);
  var clsTitle = new RegExp(pTitleClass);
  var tag = pStartNode;
  
  while(tag != null){
    if(clsRegion.test(tag.className)){
      if(clsTitle.test(tag.firstChild.className)){
        return tag.firstChild;
      }
    }
    tag = tag.parentNode;
  }
  return null;
}

/*
 * This uses the built in APEX feature to generate Comma Separated Values files from Interactive Report regions.
 * It also logs the export to the audit table. Right now only desktops have IR regions.
 *
 * pLabel: String used in the audit log and as part of the file name. Example: My Notes, Attachments for File 123
 * pButton: The button this function is attached to.
 * pPage: The page number the report is on.
 */
function getIRCSV(pLabel, pButton, pPage){
	var auditLabel = "Datagrid exported: ";
	var url = "f?p=" + apex_app + ":" + pPage + ":" + apex_session + ":";
	var filename = null;
	var title = null;
	var invalidChars = /[\/:*?"<>|]/g;

	title = getTitleNode(/region/i, /title/i, pButton);
	if(title != null){
		// If no pLabel was given use the report region text.
		if(pLabel == null || pLabel == '' || pLabel === undefined){
			filename = title.firstChild.nodeValue;
		} else {
			filename = pLabel;
		}

		url += 'CSV';
		$s('P' + pPage + '_EXPORT_NAME', filename.replace(invalidChars,' ')); // IR reports add the extension.
		// Reset this so the log shows it was the desktop that was exported.
		filename = title.firstChild.nodeValue;
		doSubmit('');

		logInfo(auditLabel + filename);
		window.location.href = url;
	}
}

/*
 * This uses the built in APEX feature to generate Comma Separated Values files from regular report regions.
 * It also logs the export to the audit table.
 *
 * pLabel: String used in the audit log and as part of the file name. Example: My Notes, Attachments for File 123
 *         This parameter can be null and if it is we will derive the label from the region title.
 * pButton: The button this function is attached to.
 * pPage: The page number the report is on.
 */
function getCSV(pLabel, pButton, pPage){
	if (checkDirty()){
		alert('You must save before you can perform this action.');
		return false;
	} else {
		var auditLabel = "Datagrid exported: ";
		var url = "f?p=" + apex_app + ":" + pPage + ":" + apex_session + ":";
		var filename = null;
		var title = null;
		var invalidChars = /[\/:*?";@=#&<>|]/g; /*added URL syntax characters (";" "@" "=" "#" "&")*/
		
		title = getTitleNode(/region/i, /title/i, pButton);
		if(title != null){
			
			var objTagline = $v('P0_OBJ_TAGLINE');
			if(objTagline == ''){
				objTagline = $v('P0_OBJ_TAGLINE_SHORT');
			}
    
			if($v('P0_OBJ_TYPE_CODE') == 'ALL.REPORT_SPEC'){
				objTagline += ' - Report Spec';
			}
			// If no pLabel was given use the report region text.
			if(pLabel == null || pLabel == '' || pLabel === undefined){
				filename = objTagline + ' - ' + title.firstChild.nodeValue;
			} else {
				filename = objTagline + ' - ' + pLabel;
			}
			url += 'FLOW_EXCEL_OUTPUT_' + title.parentNode.id + '_en-us';
			
			// Set the file name page item. This page item has to be set on the report attributes page.
			// Alternatively, you can type your own file name in the report attributes and not use the generated name.
			//$s('P' + pPage + '_EXPORT_NAME', filename.replace(invalidChars,' ') + '.csv'); // Regular reports don't add the extension.
			
			/*TMH 12/1 changed the character replace function with an encoding function that automatically chagnes all special characters
			to their uri counterparts ie ' ' becomes %20*/
			$s('P' + pPage + '_EXPORT_NAME', encodeURIComponent(filename) + '.csv'); // Regular reports don't add the extension.
			doSubmit(''); // Post the change.
    
			// Add the obj sid for the audit.
			filename = 'OBJ: ' + $v('P0_OBJ') + ' - ' + filename;
			logInfo(auditLabel + filename);
			window.location.href = url;
		}
	}	
}

function newWindow(in_opts){
	/* Set Defaults */
	o = {
	  	app          : apex_app,
		page         : -1,
		session      : apex_session, 
		request      : "", 
		debug        : apex_debug,
		clear_cache  : "",
		item_names   : "",
		item_values  : "",
		name         : "genPop",
		width        : 1000, 
		height       : 800, 
		top          : 100, 
		left         : 200,
		scrollbars   : 1, 
		resizable    : 1,
		menubar      : 1,
		directories  : 1,
		toolbar      : 1,
		status       : 1,
		location     : 1,
		copyhistory  : 1 };  

	/* Test for bogus args */
	for (var argName in in_opts) {
		if ( o[argName] == undefined) {
			alert("Sys Error(295x5vr1). Passed bogus arg(" + argName +")");
			return;
		}
	}

	/* Update defaults with args passed in */
	for (var argName in in_opts) {
		o[argName] = in_opts[argName];
	}  

	/* Must set a page */
	if ( o.page == -1 ) {
		alert("Sys err 295x5vr2.");
		return;
	}

	var d =':';
	var url = 'f?p=' + 	o.app           +d+ 
						o.page          +d+ 
						o.session       +d+ 
						o.request       +d+  
						o.debug         +d+ 
						o.clear_cache   +d+ 
						o.item_names    +d+ 
						o.item_values;

	w = open(url, o.name,  "Scrollbars="  +o.scrollbars+
		",resizable="  +o.resizable+
		",width="      +o.width+
		",height="     +o.height+
		",top="        +o.top+
		",left="       +o.left+
		",scrollbars=" +o.scrollbars+
		",menubar="    +o.menubar+
		",directories="+o.directories+
		",toolbar="    +o.toolbar+
		",status="     +o.status+
		",location="   +o.location+
		",copyhistory=" +o.copyhistory
	);

	if (w.opener == null)
		w.opener = self;

	w.focus();
}

function popup(in_opts){
	/* Set Defaults */
	o= { 
		app          : apex_app,
		page         : -1,
		session      : apex_session, 
		request      : "OPEN", 
		debug        : apex_debug,
		clear_cache  : "",
		item_names   : "",
		item_values  : "",
		name         : "genPop",
		width        : 800, 
		height       : 800, 
		top          : 100, 
		left         : 200,
		scrollbars   : 1, 
		resizable    : 1,
		menubar      : 0,
		directories  : 0,
		toolbar      : 0,
		status       : 0,
		location     : 0,
		copyhistory  : 0
	};

	/* Test for bogus args */
	for (var argName in in_opts) {
		if ( o[argName] == undefined) {
			alert("Sys Error(295x5vr1). Passed bogus arg(" + argName +")");
			return;
		}
	}

	/* Update defaults with args passed in */
	for (var argName in in_opts) {
		o[argName] = in_opts[argName];
	}

	/* Must set a page */
	if ( o.page == -1 ) {
		alert("Sys err 295x5vr2.");
		return;
	}

	var d =':';
	var url = 'f?p=' + 	o.app           +d+ 
						o.page          +d+ 
						o.session       +d+ 
						o.request       +d+  
						o.debug         +d+ 
						o.clear_cache   +d+ 
						o.item_names    +d+ 
						o.item_values;

	w = open(url, o.name,  "Scrollbars="  +o.scrollbars+
						 ",resizable="  +o.resizable+
						 ",width="      +o.width+
						 ",height="     +o.height+
						 ",top="        +o.top+
						 ",left="       +o.left+
						 ",scrollbars=" +o.scrollbars+
						 ",menubar="    +o.menubar+
						 ",directories="+o.directories+
						 ",toolbar="    +o.toolbar+
						 ",status="     +o.status+
						 ",location="   +o.location+
						 ",copyhistory=" +o.copyhistory
	);

	if (w.opener == null)
		w.opener = self;

	w.focus();
}

/* Page 800 automatically creates and serves a report. This function just provides a window for the report to display in. */
function launchReport(reportTypeSid, objSid){
	var pageNum = 800;
	var pageName = 'REPORT';
	var itemNames = 'P800_REPORT_TYPE,P0_OBJ';
	var itemVals = reportTypeSid + ',' + objSid;

	popup({ page 		: pageNum,
		name 		: pageName,
		item_names 	: itemNames,
		item_values 	: itemVals,
		clear_cache 	: pageNum});
}
/* Page 805 provides a container for html reports to be displayed in. */
function launchReportHtml(objSid){
	var pageNum = 805;
	var pageName = 'REPORT';
	var itemNames = 'P0_OBJ';
	var itemVals = objSid;

	popup({ page 		: pageNum,
		name 		: pageName,
		item_names 	: itemNames,
		item_values 	: itemVals,
		clear_cache 	: pageNum});
}

/* Page 810 provides an interface to modify the report before creating and serving it. */
function launchReportSpec(reportTypeSid, objSid){
	var pageNum = 810;
	var pageName = 'REPORT';
	var itemNames = 'P810_OBJ,P810_REPORT_TYPE';  /*jf added 6.3.10 */
	var itemVals = objSid + ',' + reportTypeSid;
	
    createReportSpec(pageNum,
	                 reportTypeSid,
					 'ALL.REPORT_SPEC',
					 itemNames,
					 itemVals);  /*jf added 6.3.10 */
}

/*function runPopWin = prevents user from launching a popup window if the page is "dirty" (contains altered fields) if checkDirty returns true an alert is launched
                        telling the user the page must be clean before this option can be used.  Else if the page is clean then launchPopWin is called.  This function
						was created so that minimal change was required to the application.  As of 10/25/10 only 3 links have been altered to call this function instead of
						thier original targets (runChecklist and changeStatus).
*/
function runPopWin (winType, objSid, statusChangeSid) {
	//if ((checkDirty()) && (!checkWritable())){
	if (checkDirty()){
		/*stubbed in case user wishes different alert message per window launched*/
		switch(winType) {
			case "Status":
				alert('You must save before you can perform this action.');
                                break;
			case "Checklist":
				alert('You must save before you can view the checklist.');
                                break;
			default:
				alert('Generic message');
		}
		/*
		//this is the here in case a generic message is acceptable
		alert(winType + " window cannot be launched until page changes are accepted.");
                */
		//this returns to the page so that no changes made, do not remove.
		return false;
	}
	else {
		//function call to launch popWin if the calling page is clean
		launchPopWin(winType, objSid, statusChangeSid);
	}
}

/*function launchPopWin = centralizes calls for showPopWin.  Function was written to keep runPopWin cleaner and simpler.  If page is clean (no altered data) this 
						function concatenates the parameters and sends them to showPopWin.  If you look at the current versions of runChecklist and changeStatus 
						you'll see that they only vary based on Numbers and Names, they both call showPopWin the same way.  Here we just switch those specific 
						variables based on the list that called it.
*/
function launchPopWin(winType, objSid, statusChangeSid) {
	var pageNum;
	var pageName;
	var itemNames;
	var itemValues;
	
	switch(winType) {
		case "Status":
			pageNum = 5450;
			pageName = 'STATUS';
			itemNames = 'P5450_STATUS_CHANGE_SID,P0_OBJ';
			break;
		case "Checklist":
			pageNum = 5500;
			pageName = 'CHECKLIST';
			itemNames = 'P5500_STATUS_CHANGE_SID,P0_OBJ';
			break;			
		default:
			alert('application error');
		}
	
	itemVals = statusChangeSid + ',' + objSid;
		
	showPopWin('f?p='+apex_app+':'+
        pageNum+':'+
        apex_session+'::NO:'+
        pageNum+':'+
        itemNames+':'+
        itemVals+':',
        780,600,null);
}

/*This function was written in effort to stop "dirty" alerts on a page that wasn't writable.
This lead to the change in setDirty function on Object with Tabs/Menus template
In theory a page will only be dirty if the user can save and/or create and thusly..
a read only page will not be dirty by a users action since he/she cannot save or create*/
function findWritableTag() {
	var anchors = document.getElementsByTagName('a');
	for (var i = 0;i<anchors.length;i++) {
		if ((/INCIDENT/.test(anchors[i].href)) || (/CREATE/.test(anchors[i].href)))
        return true;
	}
	return false;
}
		
function runDirtyTest (listType) {
	//alert("Read Only: " + findWritableTag() + " Dirty: " + checkDirty());
		if (checkDirty()) {
		//if ((checkDirty()) && (findWritableTag())){
			/*stubbed in case user wishes different alert message per menu item chosen*/
			switch(listType) {
				case "Action":
					alert('You must save before you can perform this action.');
									break;
				case "Create":
					alert('You must save before you can perform this action.');
									break;
				case "Close":
					alert('You must save your data or cancel your changes to perform this action');
									break;								
				case "Export":
					alert('You must save before you can perform this export action.');
									break;									
				case "Checklist":
					alert('You must save before you can view the checklist.');
									break;
				default:
					alert('DEFAULT: You must save before you can perform this action.');
			}
			//this is the here in case a generic message is acceptable
			//this returns to the page so that no changes made, do not remove.
			return false;
		}
	//}
	//launch href if the calling page is clean
	return true;
}

function changeStatus(objSid,statusChangeSid){
	var pageNum = 5450;
	var pageName = 'STATUS';
	var itemNames = 'P5450_STATUS_CHANGE_SID,P0_OBJ';
	var itemVals = statusChangeSid + ',' + objSid;

   showPopWin('f?p='+apex_app+':'+
              pageNum+':'+
              apex_session+'::NO:'+
              pageNum+':'+
              itemNames+':'+
              itemVals+':',
              780,600,null);

/*
	popup({ page 		: pageNum,  
		name 		: pageName,
		item_names 	: itemNames,
		item_values 	: itemVals,
		clear_cache 	: pageNum});
*/
 return null;
}

function runChecklist(objSid,statusChangeSid){
	var pageNum = 5500;
	var pageName = 'CHECKLIST';
	var itemNames = 'P5500_STATUS_CHANGE_SID,P0_OBJ';
	var itemVals = statusChangeSid + ',' + objSid;
  //alert('in runChecklist');
  showPopWin('f?p='+apex_app+':'+
              pageNum+':'+
              apex_session+'::NO:'+
              pageNum+':'+
              itemNames+':'+
              itemVals+':',
              780,600,null);
  /*
	popup({ page 		: pageNum,  
		name 		: pageName,
		item_names 	: itemNames,
		item_values 	: itemVals,
		clear_cache 	: pageNum});
  */
}
  
function addNote(noteCode, request){
	var pageNum = 700;
	var pageName = 'REQNOTE';
	var itemNames = 'P700_NOTE_CODE,P700_REQUEST';
	var itemVals = noteCode + ',' + request;

	popup({	page 		: pageNum,
	   	name 		: pageName,
	   	item_names 	: itemNames,
	   	item_values 	: itemVals,
	   	clear_cache 	: pageNum});
}

function checkForPriv(pAction,pObjType,pPersonnel,pUnit){
	var get = new htmldb_Get(null,
			    $v('pFlowId'),
			    'APPLICATION_PROCESS=Check_For_Priv',
			    $v('pFlowStepId'));  
	get.addParam('x01',pAction);
	get.addParam('x02',pObjType);
	get.addParam('x03',pPersonnel);
	get.addParam('x04',pUnit);
	gReturn = get.get();
	return gReturn.substr(0,1);
}
  
function deleteObj(obj, request){
	var ans = "";
	var pageNum = 750;
	var pageName = 'DELOBJ';
	var itemNames = 'P750_OBJ,P750_REQUEST';
	var itemVals = obj + ',' + request;
	var ht = 200;

	if (checkForPriv('DELETE',document.getElementById('P0_OBJ_TYPE_CODE').value)=='Y'){
	   if ($v('P0_WRITABLE')=='Y'){
		ans = confirm(htmldb_delete_message);
		if (ans){
			popup({	page 		: pageNum,
				name 		: pageName,
				item_names 	: itemNames,
				item_values 	: itemVals,
				clear_cache 	: pageNum,
				height 		: ht});
		}
	   }else{
	   	alert('Object is read-only.');
	   }
	}else{
		alert('You are not authorized to perform the requested action.');
	}
}

function checkDeers(participant){
	var pageNum = 30140;
	var pageName = 'DEERS';
	var itemNames = 'P30140_OBJ';
	var itemVals = participant;

	popup({	page 		  : pageNum,
	   	name 		      : pageName,
	   	item_names 	  : itemNames,
	   	item_values 	: itemVals,
	   	clear_cache 	: pageNum,
      width         : 1100});
}

function createReportSpec(pPage, pObjContext, pObjType, pOthNames, pOthVals){
      var vPageName = Date.parse(Date().toString());
	  var vNoObj = '';
      var vItemNames = 'P0_OBJ_CONTEXT,P0_OBJ_TYPE_CODE,P0_OBJ';
      var vItemVals = pObjContext + ',' + pObjType + ',' + vNoObj;
      if (pOthNames != undefined) vItemNames = vItemNames + ',' + pOthNames;
      if (pOthVals != undefined) vItemVals = vItemVals + ',' + pOthVals;

      newWindow({name : vPageName, 
	         page : pPage, 
	         clear_cache : pPage, 
	         request : 'OPEN', 
	         item_names : vItemNames, 
	         item_values : vItemVals});
}