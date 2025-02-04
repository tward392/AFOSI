set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_DOCUMENT_REVIEW" as
/******************************************************************************
   Name:     Osi_document_review
   Purpose:  Provides Functionality For Document Review Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    22-May-2009 M.Batdorf       Created this package body. log_error, get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.
    26-Jul-2012 Tim Ward        CR#4050 - Document Reviews can not have multiples in the same activity.
                                 Changed create_instance.
                                 Added get_narrative.
                                 Changed clone.
    06-Sep-2012 Tim Ward        CR#4050 - When Narrative is generated "On 05 Sep 12, A " needs to
                                 be "On 05 Sep 12, a ".
                                 Changed get_narrative.
    18-Oct-2012 Tim Ward        CR#4152 - Check use_date_in_narrative field.
                                 Changed get_narrative.
                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_DOCUMENT_REVIEW';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = '
                      || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function get_narrative(p_obj in varchar2) return clob is
    
         v_Narrative clob;
         v_Narrative_Temp clob;
         
    begin
         for i in (select * from t_osi_a_document_review where obj=p_obj order by activity_date,sid)
         loop
             if (substr(i.narrative,1,2)='A ') then
             
               v_Narrative_Temp := 'a ' || substr(i.narrative,3);
             
             else

               v_Narrative_Temp := i.narrative;
             
             end if;
             v_Narrative := v_Narrative || CASE i.use_date_in_narrative WHEN 'Y' THEN 'On ' || to_char(i.activity_date,'DD Mon YY') || ', ' ELSE '' END || v_Narrative_Temp || CHR(13) || CHR(10) || CHR(13) || CHR(10);
             
         end loop;
         
         return v_Narrative;
         
    exception
        when others then
            log_error('get_narrative: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_narrative;

   function create_instance(p_personnelSID in varchar2) return varchar2 is
        v_count                  number := 1;
        v_act_count              number;
        v_ParticipantUsage       varchar2(100) := 'PARTICIPANTS';
        v_ParticipantCode        varchar2(100) := 'SUBJECT';
        v_AddressUsage           varchar2(100) := NULL;
        v_AddressCode            varchar2(100) := NULL;
        v_Participant_Version    varchar2(20);
        v_sid                    t_core_obj.sid%type;
        v_obj                    t_core_obj.sid%type;
        v_obj_type_sid           varchar2(20) := core_obj.lookup_objtype('ACT.DOCUMENT_REVIEW');
    begin
         for i in (SELECT * FROM T_OSI_A_RC_DR_MULTI_TEMP WHERE PERSONNEL=p_personnelSID and OBJ_TYPE_CODE='ACT.DOCUMENT_REVIEW')
         loop
             v_Participant_Version:=osi_participant.get_current_version(i.subject_of_activity);

             if (v_count = 1) then

               v_obj := osi_activity.create_instance(v_obj_type_sid,
                                                     i.activity_date,
                                                     i.title,
                                                     i.restriction,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     v_Participant_Version,
                                                     v_ParticipantUsage,
                                                     v_ParticipantCode,
                                                     NULL,
                                                     i.file_sid,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     replace(i.wh_pay_cat,'%null%','null'),
                                                     replace(i.wh_duty_cat,'%null%','null'),
                                                     replace(i.wh_mission,'%null%','null'),
                                                     i.wh_date,
                                                     i.wh_hours,
                                                     i.complete,
                                                     i.substantive);
                                                   
                                                              
            end if;
            
            insert into t_osi_a_document_review (activity_date,document_number,narrative,doc_type,results,obj,explanation)
                  values (i.activity_date,i.reference_num,i.narrative,i.doc_type,i.results,v_obj,i.explanation) returning sid into v_sid;
            commit;
            
            select count(*) into v_act_count from t_osi_a_document_review where sid=v_sid;
        
            if (v_act_count > 0) then

              delete from T_OSI_A_RC_DR_MULTI_TEMP where sid=i.sid;

            end if;
            v_count := v_count + 1;
            
         end loop;

         recent_access(v_obj, p_personnelSID);
         return v_obj;
        
    exception
        when others then
            log_error('create_instance error, ' || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
    begin
        --- Get Document Review Activity record ---
        for a in (select * from t_osi_a_document_review where sid=p_obj)
        loop
            --- Insert a new Document Review Activity record ---
            insert into t_osi_a_document_review (obj, doc_type, document_number, explanation, narrative, activity_date, results) values (p_new_sid, a.doc_type, a.document_number, a.explanation, a.narrative, a.activity_date, a.results);

        end loop;
        
    exception
        when others then
            log_error('osi_document_review.clone: p_obj = ' || nvl(p_obj, 'null')
                      || ', p_new_sid = ' || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_document_review;
/
