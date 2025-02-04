/***********************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
**** YOU MUST BE LOGGED IN AS SYSDBA TO CREATE THIS IN THE APEX_PUBLIC_USER SCHEMA          ****
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************/
-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE APEX_PUBLIC_USER.rest_handler
as
/******************************************************************************
   Name:     rest_handler
   Purpose:  A simple example of RESTful web services with PL/SQL (see http://en.wikipedia.org/wiki/Representational_State_Transfer#RESTful_web_services)

   Remarks:      The DAD must be configured to use a path-alias and path-alias-procedure

   Revisions:
     Date         Author          Description
     -----------  --------------  ------------------------------------
     14-Mar-2011  Tim Ward        Created Package
     
******************************************************************************/
-- the main procedure that will handle all incoming requests
procedure handle_request (p_path in varchar2);

end rest_handler;
/


CREATE OR REPLACE PACKAGE BODY APEX_PUBLIC_USER.rest_handler
as
/******************************************************************************
   Name:     rest_handler
   Purpose:  A simple example of RESTful web services with PL/SQL (see http://en.wikipedia.org/wiki/Representational_State_Transfer#RESTful_web_services)

   Remarks:      The DAD must be configured to use a path-alias and path-alias-procedure

   Revisions:
     Date         Author          Description
     -----------  --------------  ------------------------------------
     14-Mar-2011  Tim Ward        Created Package
     
******************************************************************************/
g_request_method_get           constant varchar2(10)  := 'GET';
g_request_method_post          constant varchar2(10)  := 'POST';
g_request_method_put           constant varchar2(10)  := 'PUT';
g_request_method_delete        constant varchar2(10)  := 'DELETE';
base_url                                varchar2(255) := 'https://hqcuiwi2ms01.ogn.af.mil:4443/pls/apex/f?p=100:';
apex_page                               varchar2(255) := '1000';
url_suffix                              varchar2(255);

procedure handle_request (p_path in varchar2) as

  l_request_method constant varchar2(10) := owa_util.get_cgi_env('REQUEST_METHOD');
  l_path_elements  apex_application_global.vc_arr2;
  l_resource       varchar2(2000);
  l_id             varchar2(2000);

begin
     -- note that an extra delimiter is added to the path, in case the user leaves out the trailing slash
     l_path_elements := apex_util.string_to_table (p_path || '/', '/');

     begin
  
          l_resource := l_path_elements(1);
          l_id := l_path_elements(2);

     exception
       when value_error or no_data_found then
 
           l_resource := null;
           l_id := null;
  
     end;
 
     case l_resource

         when 'pSid' then
             
             if l_id is null or l_id = '' then

               apex_page := '1000';
               url_suffix := ''; 

             else

               apex_page := '105';
               url_suffix := ':OPEN:NO:20000:P105_OBJ_TO_OPEN:' || l_id;
                
             end if;
             
         else

           apex_page := '1000';
           url_suffix := ''; 

     end case;

     apex_application.g_flow_id := 100;
     owa_util.redirect_url(base_url || apex_page || ':' || apex_custom_auth.get_session_id_from_cookie || url_suffix, true);

end handle_request;

end rest_handler;
/