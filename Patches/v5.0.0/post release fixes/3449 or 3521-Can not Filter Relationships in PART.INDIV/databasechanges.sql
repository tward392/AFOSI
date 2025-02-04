create or replace function IsNumeric (p_string in varchar2) return boolean is
  v_number number;
begin
  v_number := p_string;
  return true;
exception
  when others then
    return false;
end;

CREATE OR REPLACE FUNCTION "SSN_CONTAINS_STRING" (p_ssn in varchar2) return varchar2 is
  
  v_ssn varchar2(4000);
  
begin
     
     v_ssn := p_ssn;
     
     if length(v_ssn) = 9 and IsNumeric(p_ssn) = True then
       
       v_ssn := v_ssn || '% | %' || substr(p_ssn, 1, 3) || '+' || substr(p_ssn, 4, 2) || '+' || substr(p_ssn, 6, 4);
       
     elsif REGEXP_INSTR(v_ssn, '^[0-9]{3}-[0-9]{2}-[0-9]{4}$') > 0 then

       v_ssn := v_ssn || '% | %' || substr(p_ssn, 1, 3) || substr(p_ssn, 5, 2) || substr(p_ssn, 8, 4);
     
     end if;
      
     return replace(replace(v_ssn,'-','+'),'''','''''');

end SSN_CONTAINS_STRING;
/
