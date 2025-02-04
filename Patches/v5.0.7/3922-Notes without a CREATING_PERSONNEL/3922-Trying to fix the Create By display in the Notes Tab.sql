/* STEP 1, FIX Imported Personnel Records about 6000 */
--update t_osi_note set creating_personnel='777011UK' where note_text like '%This user was imported from Legacy I2MS%' and creating_personnel is null;
--commit;

/* STEP 2, FIX Imported Personnel Notes about 2079 */
--update t_osi_note set creating_personnel='777011UK' where create_by='AFOSINET\wayne.combs.csa' and creating_personnel is null;
--commit;

/* STEP 3, FIX ones create in WebI2MS that have blank creating_personnel ABOUT 53 */
--begin
--for a in (select p.sid as personnel_sid,n.sid as note_sid from t_osi_note n,t_core_personnel p where creating_personnel is null and LAST_NAME || ', ' || FIRST_NAME || decode(MIDDLE_NAME,NULL,'',' ') || MIDDLE_NAME = n.create_by)
--loop
--    update t_osi_note set creating_personnel=a.personnel_sid where sid=a.note_sid;
--end loop;
--commit;             
--end;

/* STEP 4, FIX the Oddballs (users that now have middle names) about 3 */
--update t_osi_note set creating_personnel='77700Q3C' where sid='7770X508';
--commit;
--
--update t_osi_note set creating_personnel='77700130' where sid='7771K4A8';
--commit;
--
--update t_osi_note set creating_personnel='7771XX8Z' where sid='77732S84';
--commit;
select n.sid,o.sid,n.create_on,ot.description,nt.description,n.create_by,n.note_text from t_osi_note n,t_osi_note_type nt,t_core_obj o,t_core_obj_type ot 
             where n.note_type=nt.sid 
               and n.obj=o.sid
               and o.obj_type=ot.sid    
               and creating_personnel is null
               order by n.create_on
