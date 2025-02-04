-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PROCEDURE recent_access (v_obj in varchar2, v_user_sid in varchar2) is
begin

  for c in (select replace(replace(nvl(column_value,'-'),chr(10),'-'),chr(13),'-') as column_value from table(split(v_obj,':')))
  loop
      if c.column_value != '-' then

        update t_osi_personnel_recent_objects
           set times_accessed= times_accessed+ 1,
               last_accessed= sysdate
         where personnel = v_user_sid
           and obj = c.column_value;

        if sql%rowcount = 0 then
          
            begin
                 insert into t_osi_personnel_recent_objects
                         (personnel, 
                          obj, 
                          unit, 
                          times_accessed, 
                          last_accessed)
                 values (v_user_sid, 
                         c.column_value, 
                         osi_personnel.get_current_unit(v_user_sid), 
                         1, 
                         sysdate);
            exception when others then

                     null;

            end;

        end if;

      end if;

  end loop;
  
end recent_access;
/

