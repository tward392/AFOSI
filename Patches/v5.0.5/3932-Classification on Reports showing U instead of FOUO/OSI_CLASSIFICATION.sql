CREATE OR REPLACE PACKAGE BODY "OSI_CLASSIFICATION" as
/******************************************************************************
   Name:     osi_classification
   Purpose:  Provides functionality for classifying objects and reports.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------
    03-Dec-2009  T.Whitehead     Created package.
    20-Oct-2011  Tim Ward        CR#3932 - Classification on Reports is wrong.
                                  Added OSI.DEFAULT_REPORT_CLASS to T_CORE_CONFIG.
                                  Changed get_report_class here to use that value.
                                  Makes it work like Legacy Now.
******************************************************************************/
c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_CLASSIFICATION';
    
procedure log_error(p_msg in varchar2) is
begin

     core_logger.log_it(c_pipe, p_msg);

end log_error;
    
function get_report_class(p_obj in varchar2) return varchar2 is

  v_classification VARCHAR2(32000) := NULL;
  v_FileSID VARCHAR2(20) := NULL;

begin
     log_error('<<<get_report_class-' || p_obj);

     --- If this is an Activity, See if it is associated with a File --- 
     for a in (select file_sid from t_osi_assoc_fle_act where activity_sid=p_obj)
     loop

         v_FileSID := a.file_sid;
         log_error('Associated File SID-' || v_FileSID);
   
     end loop;
        
     --- Retrieve Classification Level  (U=Unclassified, C=Confidential, and S=Secret) --- 
     v_classification := core_classification.Full_Marking(p_obj);
     log_error('Object Classification=' || v_classification);

     -- If Object is NOT Classified, check for a Parent Classification --- 
     if v_classification is null or v_classification = '' then
    
       --- Try to Get the Classification of the File --- 
       v_classification := core_classification.Full_Marking(v_FileSID);
       log_error('Associated File SID-' || v_FileSID || ', Classification=' || v_classification);
    
     END IF;
     
     -- If Object is NOT Classified and the parent is NOT Classified, check for a Default Value --- 
     if v_classification is null or v_classification = '' then

       v_classification := core_util.get_config('OSI.DEFAULT_REPORT_CLASS');
       log_error('OSI.DEFAULT_REPORT_CLASS=' || v_classification);
     
     end if;
          
     if v_classification is null or v_classification = '' then

       v_classification := core_util.get_config('OSI.DEFAULT_CLASS');
       log_error('OSI.DEFAULT_CLASS=' || v_classification);

     end if;

     log_error('>>>get_report_class-' || p_obj || ',Classification=' || v_classification);
     return v_classification;
          
exception when others then

    log_error('get_report_class: ' || sqlerrm);
    return 'get_report_class: Error';

end get_report_class;

end osi_classification;
/