//<![CDATA[
 
   $(document).ready(function(){
      var pageID = $('#pFlowId').val();

 
      $('.hoverHelp').each( function(i) {
            var $item = $(this);
            var get = new htmldb_Get(null,pageID,'APPLICATION_PROCESS=ITEM_HELP',0);
            get.add('TEMP_ITEM', $item.prop('for'));
            $item.prop('rel', get.url());
            $item.prop('relTitle', $item.html());
            return true;
      });
 
      $('.hoverHelp').cluetip({
         arrows: true,
         titleAttribute: 'relTitle',
         hoverIntent: {    
            sensitivity: 2,
            interval: 200,
            timeout: 0
          }
      }); 

      // -- Handle Help Button --
      //$('#apexir_ACTIONSMENU a[title="Help"]').prop({'href':'&HELP_URL.','target':'_blank'});
      $('#apexir_ACTIONSMENU a[title="Help"]').prop({'href':helpURL,'target':'_blank'});
   });
 
//]]>