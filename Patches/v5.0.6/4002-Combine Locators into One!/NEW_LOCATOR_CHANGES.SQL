27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.



**VIEW BUTTON**
javascript:getObjURL('3330BVNI');
'<a title="View Unit" href="' || osi_object.get_object_url(:P30605_UNIT_SID) || '">&ICON_MAGNIFY.</a>'




HTML HEADER

"JS_JQUERY_OPENLOCATOR"



<a href="javascript:openLocator('301','P#_RETURN_ITEM_NAME','Y','&P#_EXCLUDE_SIDS.','OPEN','','','Choose Files...','UNITS','&P0_OBJ.');">&ICON_LOCATOR.</a>


--Exclude Types
javascript:openLocator('301','P5300_SEL_PARTICIPANT','Y','&P5300_EXCLUDE.','OPEN','P301_ACTIVE_FILTER_EXCLUDES','All Participant Types;ALL~Individuals by Name;PART.INDIV~Programs;PART.NONINDIV.PROG','Choose Participants...','PARTICIPANT','&P0_OBJ.');


--Exclude all but INDIVIDUAL PARTICIPANTS---
<a href="javascript:openLocator('301','P11500_SOURCE','N','','OPEN','P301_ACTIVE_FILTER_EXCLUDES','All Participant Types;ALL~Programs;PART.NONINDIV.PROG~Companies;PART.NONINDIV.COMP~Organizations;PART.NONINDIV.ORG','Choose Participant...','PARTICIPANT','&P0_OBJ.');">&ICON_LOCATOR.</a>



---Button Style
style="vertical-align:bottom; padding-left:2px;"




------NEW STUFF ADDED TO THE DATE TIME PICKERS----
  // Add a Today Link to each Date Picker //
  $('input.datepickernew').datepicker().next('.ui-datepicker-trigger').after('<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>');
  $('a.pickToday').click(function() {$(this).prev().prev('input.datepickernew').datepicker('setDate', new Date());});
 });
</script>

<!-- Align the Calendar Image better -->
<style>
.ui-datepicker-trigger
{
 margin-left : 2px;
 vertical-align : bottom;
 cursor: pointer;
}
</style>