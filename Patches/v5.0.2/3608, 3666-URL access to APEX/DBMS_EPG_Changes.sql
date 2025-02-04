begin

     dbms_epg.set_dad_attribute (dad_name => 'APEX', attr_name => 'path-alias', attr_value => 'i2ms');
     dbms_epg.set_dad_attribute (dad_name => 'APEX', attr_name => 'path-alias-procedure', attr_value => 'rest_handler.handle_request');

end;
/

----See all DADS Attributes----
set serveroutput on
 
declare
  tab_attr    dbms_epg.varchar2_table;
  tab_val     dbms_epg.varchar2_table;
begin
  dbms_epg.get_all_dad_attributes('APEX', tab_attr, tab_val);
  for i in 1..tab_attr.count
  loop
    dbms_output.put_line(tab_attr(i) || ':' || tab_val(i)); 
  end loop;
end;
/ 
