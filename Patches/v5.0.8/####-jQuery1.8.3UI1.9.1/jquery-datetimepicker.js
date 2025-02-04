/*
    History:

        06-Sep-2012 Tim Ward   Removed getElementsByClassName calls, not needed.

*/


$(document).ready(function () {
     $(".datepicker > input[id]").datepicker();

  $.datepicker.setDefaults({
      dateFormat: 'dd-M-yy',
      changeMonth: true,
      changeYear: true,
      closeText: 'Done',
      showButtonPanel: true,
      duration: 'slow',
      prevText: 'Previous',
      showOtherMonths: true,
      selectOtherMonths: true,
      dayNamesShort: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
      dayNamesMin: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
      constrainInput: true,
      showOn: 'both',
      buttonImage: imgPrefix+'CalendarR24.png',
      buttonImageOnly: true,
      buttonText: 'Calendar',
      autoSize: true,
      yearRange:'c-100:c+10'
  });

});

$(function(){
             // Remove Original Date Picker //
             $("td.datepicker + td").remove();

             // Add jQuery DatePicker to all DatePicker input fields not hidden //
             $("td.datepicker > input[type!=hidden]").datepicker();
            });

$(document).ready(function()
 {
  $('.datepickernew').each(function() 
   {
    if (typeof this.type == "undefined")
      {
       $(this).removeClass("datepickernew");
       $(this).addClass("datepickerdisabled");
      }
   });

  $(".datepickernew").datepicker();  $(".datepickernew").datepicker();

  // Add a Today Link to each Date Picker //
  $('input.datepickernew').datepicker().next('.ui-datepicker-trigger').after('<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="'+imgPrefix+'TodayR24.png" alt="Today" title="Today"></a>');
  $('a.pickToday').click(function() {$(this).prev().prev('input.datepickernew').datepicker('setDate', new Date());});
 });
