CREATE OR REPLACE VIEW V_OSI_EVIDENCE
(SID, OBJ, STATUS_SID, DESCRIPTION, OBTAINED_BY_SID, 
 OBTAINED_DATE, EVIDENCE_UNIT_SID, SEQ_NUM, TRANSFERRED_FROM_UNIT_SID, UNIT_SID, 
 STORAGE_LOCATION, SPLIT_TAG_CHAR, OBJ_TAGLINE, TAG_NUMBER, STATUS, 
 STATUS_CODE, OBTAINED_BY, OBTAINED_AT, ACTIVITY, ACTIVITY_ID, 
 OBTAINED_BY_UNIT_NAME, ODSO_COMMENT, IDENTIFY_AS)
AS 
select e.sid, e.obj, e.status_sid, e.description,
           e.obtained_by_sid, e.obtained_date,
           e.unit_sid evidence_unit_sid, e.seq_num,
           e.transferred_from_unit_sid, e.unit_sid,
           e.storage_location, e.split_tag_char,
           osi_object.get_tagline_link(e.obj) obj_tagline,
           a.id || '-' || e.seq_num || e.split_tag_char tag_number,
           s.description status, s.code status_code,
           osi_personnel.get_name(e.obtained_by_sid) obtained_by,
           osi_address.get_addr_display(osi_address.get_address_sid(e.sid,'OBTAINED_AT'),'SID',' ') obtained_at,
           a.sid activity, a.id activity_id,
           osi_unit.get_name(e.obtained_by_unit_sid) obtained_by_unit_name,
           e.odso_comment,
           e.identify_as
      from t_osi_evidence e,
           t_osi_activity a,
           t_osi_reference s
     where e.obj = a.sid and s.sid = e.status_sid
/