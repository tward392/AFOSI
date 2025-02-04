CREATE OR REPLACE package body osi_source_meet as
/******************************************************************************
   Name:     osi_source_meet
   Purpose:  Provides functionality for Source Meet objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------
    19-Nov-2009  T.Whitehead     Created package.
    30-Nov-2009  T.Whitehead     Added run_report.
    07-Jul-2010  J.Faris         Fixed a no_data_found bug at beginning of run_report, can occur
                                 when being run from a source file, updated log_error w/line numbers.
    07-Jan-2011  Tim Ward        Added Info Received and Levied back to the Report.
                                  Changed in run_report.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_SOURCE_MEET';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function create_instance(
        p_title            in   varchar2,
        p_source           in   varchar2,
        p_meet_date        in   date,
        p_meet_hour        in   varchar2,
        p_meet_minute      in   varchar2,
        p_commodity        in   varchar2,
        p_contact_method   in   varchar2,
        p_restriction      in   varchar2,
        p_narrative        in   clob)
        return varchar2 is
        v_sid        t_core_obj.sid%type;
        v_obj_type   t_core_obj_type.sid%type;
        v_new_date   date;
    begin
        v_obj_type := core_obj.lookup_objtype('ACT.SOURCE_MEET');
        v_sid :=
            osi_activity.create_instance(v_obj_type,
                                         p_meet_date,
                                         p_title,
                                         p_restriction,
                                         p_narrative);
        v_new_date :=
            to_date(to_char(p_meet_date, 'yyyymmdd') || nvl(p_meet_hour, '00')
                    || nvl(p_meet_minute, '00') || '00',
                    'yyyymmddhh24miss');

        update t_osi_activity
           set source = p_source,
               activity_date = v_new_date
         where sid = v_sid;

        insert into t_osi_a_source_meet
                    (sid, contact_method, commodity)
             values (v_sid, p_contact_method, p_commodity);

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function run_report(
        p_obj                      in   varchar2,
        p_multiple                 in   boolean := false,
        p_replace_classification   in   boolean := true)
        return clob is
        v_ok                    varchar2(5000);
        v_temp                  varchar2(32767);
        v_clob                  clob;
        v_clob_temp             clob;
        v_template_date         date;
        v_lead_support_agents   varchar2(4000);
        v_format                varchar2(4)                                             := 'RTF';
        v_date_format           t_core_config.setting%type;
        v_mime_type             t_core_template.mime_type%type;
        v_mime_disp             t_core_template.mime_disposition%type;
        v_source_id             v_osi_srcmeet_details.source_id%type;
        v_activity_id           v_osi_srcmeet_details.activity_id%type;
        v_meet_date             v_osi_srcmeet_details.meet_date%type;
        v_contact_method        v_osi_srcmeet_details.contact_method_description%type;
        v_location              v_osi_srcmeet_details.location%type;
        v_create_by             v_osi_srcmeet_details.create_by%type;
        v_info_received         v_osi_srcmeet_details.info_received%type;
        v_info_levied           v_osi_srcmeet_details.info_levied%type;
    begin
        v_date_format := core_util.get_config('CORE.DATE_FMT_DAY');
        
        osi_report.load_agents_assigned(p_obj);
        
        begin
            -- Load the variables up with some data.
            select source_id, activity_id, meet_date, nvl(contact_method_description, 'Unknown'),
                   nvl(osi_address.get_addr_display(location, 1, ' '), 'Unknown'), create_by,
                   nvl(info_received,'None'), nvl(info_levied,'None'), lead_support_agents
              into v_source_id, v_activity_id, v_meet_date, v_contact_method,
                   v_location, v_create_by, v_info_received, v_info_levied, v_lead_support_agents 
              from v_osi_rpt_srcmeet
             where sid = p_obj;
        exception
             when NO_DATA_FOUND then
                  v_clob := null;
                  return v_clob;
        end;


        --Get latest template
        v_ok :=
            core_template.get_latest('SOURCE_MEET',
                                     v_clob,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        -- Fill in most of the template.
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'SRC_NUM',
                                      osi_report.replace_special_chars(v_source_id, v_format),
                                      p_multiple       => true);
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'ACTIVITY_ID',
                                      osi_report.replace_special_chars(v_activity_id, v_format));
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'MEET_DATE',
                                      osi_report.replace_special_chars(to_char(v_meet_date,
                                                                               v_date_format),
                                                                       v_format));
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'INTERVIEW_TYPE',
                                      osi_report.replace_special_chars(v_contact_method, v_format));
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'LOCATION',
                                      osi_report.replace_special_chars(v_location, v_format));
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'AGENT_ENTERING_MEET',
                                      osi_report.replace_special_chars(v_create_by, v_format));

        v_ok :=
            core_template.replace_tag(v_clob,
                                      'INFO_RECEIVED',
                                      osi_report.replace_special_chars(v_info_received, v_format));
                                      
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'INFO_LEVIED',
                                      osi_report.replace_special_chars(v_info_levied, v_format));
        
        v_ok :=
            core_template.replace_tag(v_clob,
                                      'LEAD_SUPPORT_AGENTS',
                                      osi_report.replace_special_chars(v_lead_support_agents,
                                                                       v_format));
        -- Reset the temp variable.
        v_temp := null;
        -- Include the time for note data.
        v_date_format := v_date_format || ' ' || core_util.get_config('CORE.DATE_FMT_SECOND');

        -- Get the notes.
        for x in (select   n.modify_on, osi_personnel.get_name(n.creating_personnel) as personnel,
                           n.note_text
                      from t_osi_note n, t_osi_note_type nt
                     where n.obj = p_obj
                       and n.note_type = nt.sid
                       --and nt.obj_type member of osi_object.get_objtypes(p_obj)
                       and nt.code = 'IDP'
                       and nt.usage = 'NOTELIST'
                       and nt.active = 'Y'
                  order by n.create_on desc)
        loop
            v_temp :=
                v_temp || to_char(x.modify_on, v_date_format) || osi_rtf.crlf || x.personnel
                || osi_rtf.crlf || osi_report.replace_special_chars(x.note_text, v_format) || osi_rtf.crlf(2);
        end loop;

        if (v_temp is null) then
            v_temp := 'None';
        else
            v_temp := rtrim(v_temp, osi_rtf.crlf);
        end if;

        v_ok := core_template.replace_tag(v_clob, 'NOTES', v_temp);
        v_temp := null;

        -- Get the training data.
        for x in (select r.description, st.comments
                    from t_osi_a_srcmeet_training st, t_osi_reference r
                   where st.obj = p_obj and st.training = r.sid)
        loop
            v_temp := v_temp || x.description || ': ' || x.comments || osi_rtf.crlf;
        end loop;

        if (v_temp is null) then
            v_temp := 'None';
        end if;

        v_ok := core_template.replace_tag(v_clob, 'TRAINING', v_temp);
        v_temp := null;

        -- See if there are any expenditures.
        select count(1)
          into v_temp
          from v_cfunds_expense_v3
         where parent = p_obj;

        if (v_temp > 0) then
            -- Add a new line to separate the table from the word "Expenditures" in the template.
            osi_util.aitc(v_clob_temp, osi_rtf.crlf);
            -- Add the table header.
            osi_util.aitc(v_clob_temp,
                          osi_rtf.new_row || osi_rtf.new_cell(2160) || osi_rtf.new_cell(11366));
            osi_util.aitc(v_clob_temp,
                          osi_rtf.put_in_row(osi_rtf.put_in_cell('\fs20 US Currency Amount')
                                             || osi_rtf.put_in_cell('\fs20 Paragraph')));

            for x in (select parent as source_meet, total_amount_us,
                             rtrim(paragraph || ' - ' || paragraph_content, ' -') as paragraph
                        from v_cfunds_expense_v3
                       where parent = p_obj)
            loop
                -- Add a new row to the table before adding the data.
                osi_util.aitc(v_clob_temp,
                              osi_rtf.new_row || osi_rtf.new_cell(2160) || osi_rtf.new_cell(11366));
                osi_util.aitc
                    (v_clob_temp,
                     osi_rtf.put_in_row
                                      (osi_rtf.put_in_cell(trim(to_char(x.total_amount_us,
                                                                        '$9,999,999,999,990.00')))
                                       || osi_rtf.put_in_cell(x.paragraph)));
            end loop;
        else
            v_clob_temp := 'None';
        end if;

        if (p_multiple) then
            osi_util.aitc(v_clob_temp, osi_rtf.page_break);
            v_ok := core_template.replace_tag(v_clob, 'EXPENDITURES', v_clob_temp);
        else
            v_ok := core_template.replace_tag(v_clob, 'EXPENDITURES', v_clob_temp);
        end if;

        if (p_replace_classification) then
            v_temp := osi_classification.get_report_class(p_obj);
            v_ok :=
                core_template.replace_tag(v_clob,
                                          'CLASSIFICATION',
                                          osi_report.replace_special_chars(v_temp, v_format),
                                          p_multiple       => true);
        end if;

        return v_clob;
    exception
        when others then
            log_error('run_report: ' || sqlerrm  || ' ' || dbms_utility.format_error_backtrace);
            return 'run_report: Error';
    end run_report;

    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_sid   t_core_obj.sid%type;
    begin
        v_sid := null;
    exception
        when others then
            log_error('clone: ' || sqlerrm);
            raise;
    end clone;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;
end osi_source_meet;
/
