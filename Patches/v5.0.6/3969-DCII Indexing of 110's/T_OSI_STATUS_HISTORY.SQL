CREATE OR REPLACE TRIGGER WEBI2MS.osi_stathist_a_i_dcii
    after insert
    on t_osi_status_history
    referencing new as new old as old
    for each row
declare
    c_pipe      varchar2(100)               := core_util.get_config('CORE.PIPE_PREFIX') || 'DCII';
    v_objtype   t_core_obj_type.code%type;
    v_status    t_osi_status.code%type;
begin
     begin
          select code into v_objtype from t_core_obj_type where sid = core_obj.get_objtype(:new.obj);
     exception
         when no_data_found then
             core_logger.log_it(c_pipe, 'Unknown object type for obj: ' || :new.obj);
             return;
         when others then
             core_logger.log_it(c_pipe, sqlerrm);
             return;
     end;

     begin
          select code into v_status from t_osi_status where sid = :new.status;
     exception
          when no_data_found then
              core_logger.log_it(c_pipe, 'Unknown status: ' || :new.status);
              return;
          when others then
              core_logger.log_it(c_pipe, sqlerrm);
              return;
     end;

     --- Investigative Files, Security Poly Files, and DCII Indexing Files ---
     if (v_objtype in('FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO', 'FILE.POLY_FILE.SEC', 'FILE.SFS') and v_status in('OP', 'CL')) then

        insert into t_dcii_files (fyle, status, indexed_on) values (:new.obj, v_status, sysdate);
     
     --- AFOSI Application File ---
     elsif (v_objtype='FILE.AAPP' and v_status='CL') then
  
          insert into t_dcii_files (fyle, status, indexed_on) values (:new.obj, v_status, sysdate);
        
     end if;
end;
/


