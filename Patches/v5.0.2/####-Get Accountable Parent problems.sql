CREATE OR REPLACE FUNCTION "GET_ACCOUNTABLE_PARENT" (cunit in varchar2)
    return varchar2 is
begin
    for n in (select u.sid, r.code as unit_type, unit_parent, osi_unit.get_name(u.sid) unit_name
                    from t_osi_unit u, t_osi_reference r
                   where u.unit_type=r.sid 
                     and u.sid <> cunit
              start with u.sid = cunit
              connect by prior unit_parent = u.sid)
    loop
        if    n.unit_type = 'REGN'
           or n.unit_parent is null
           or n.unit_name = 'USAFSIA' then
            return(n.sid);
        end if;
    end loop;

    return('Error');                                                        --Should not be possible
end get_accountable_parent;
/