CREATE OR REPLACE PACKAGE BODY "OSI_CLASSIFICATION" as
/******************************************************************************
   Name:     osi_classification
   Purpose:  Provides functionality for classifying objects and reports.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------
    03-Dec-2009  T.Whitehead     Created package.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_CLASSIFICATION';
    
    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    function get_report_class(p_obj in varchar2) return varchar2 is
    begin
        return core_util.get_config('OSI.DEFAULT_CLASS');
    exception when others then
        log_error('get_report_class: ' || sqlerrm);
        return 'get_report_class: Error';
    end get_report_class;
end osi_classification;
/
