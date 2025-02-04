function checkForPriv(pAction,pObjType,pPersonnel,pUnit)
{
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

function createObject(pPage, pObjType, pOthNames, pOthVals)
{
 if(checkForPriv('CREATE',pObjType)=='Y')
   {
    var vPageName = Date.parse(Date().toString());
    var vItemNames = 'P0_OBJ,P0_OBJ_TYPE_CODE';
    var vItemVals = ',' + pObjType;
    
    if (pOthNames != undefined) 
      vItemNames = vItemNames + ',' + pOthNames;

    if (pOthVals != undefined) 
      vItemVals = vItemVals + ',' + pOthVals;

    logInfo('Create ' + pObjType);

    newWindow({name : vPageName, 
              page : pPage, 
              clear_cache : pPage, 
              request : 'CREATE_OBJ', 
              item_names : vItemNames, 
              item_values : vItemVals});
   } 
 else 
   {
    alert('You are not authorized to perform the requested action.');
   }
}

function dtHideExcept(pId)
{
 var id;
 var tags = document.getElementsByTagName("tbody");
    
 for (var i=0;i<tags.length;i++)
    {
     id = tags[i].id.substring(9,0);

     if(id == "dtNavBody")
       hidediv(tags[i].id);
    }
 showdiv(pId);
}

function initNav()
{
 var pageNum = parseInt(document.getElementById("pFlowStepId").value);
 var elements = document.getElementsByName("dtNavBody");
 
 switch($v('P0_DESKTOP_NAVIGATION'))
       {
         case 'I2MS_DESKTOP':
                             dtHideExcept(elements[0].parentNode.id);
                             break;

                case 'FILES':
                             dtHideExcept(elements[1].parentNode.id);
                             break;

        case 'INVESTIGATIVE':
                             dtHideExcept(elements[2].parentNode.id);
                             break;

           case 'MANAGEMENT':
                             dtHideExcept(elements[3].parentNode.id);
                             break;

              case 'SERVICE':
                             dtHideExcept(elements[4].parentNode.id);
                             break;

              case 'SUPPORT':
                             dtHideExcept(elements[5].parentNode.id);
                             break;

         case 'PARTICIPANTS':
                             dtHideExcept(elements[6].parentNode.id);
                             break;

                     default:
                             dtHideExcept(elements[0].parentNode.id);
                             break;
       }
}

function hidediv(pId) 
{
 //safe function to hide an element with a specified id
 if (document.getElementById) 
    { 
     // DOM3 = IE5, NS6
     document.getElementById(pId).style.display = 'none';
    }
  else 
    {
     if (document.layers) 
       { 
        // Netscape 4
        document.id.display = 'none';
       }
     else 
       { 
        // IE 4
        document.all.id.style.display = 'none';
       }
    }
}

function showdiv(pId) 
{
 //safe function to show an element with a specified id
 if (document.getElementById) 
    { 
     // DOM3 = IE5, NS6
     document.getElementById(pId).style.display = 'block';
    }
  else 
    {
     if (document.layers) 
       { 
        // Netscape 4
	document.id.display = 'block';
       }
     else 
       { 
        // IE 4
        document.all.id.style.display = 'block';
       }
    }
}

function getObjURL(pObj)
{
 var get = new htmldb_Get(null,
                          $v('pFlowId'),
                          'APPLICATION_PROCESS=Get_Obj_URL',
                          $v('pFlowStepId'));  
 get.addParam('x01',pObj);
 gReturn = get.get();
 eval(gReturn);
}