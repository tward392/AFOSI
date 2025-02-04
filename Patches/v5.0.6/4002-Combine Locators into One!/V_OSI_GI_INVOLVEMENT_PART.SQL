CREATE OR REPLACE VIEW V_OSI_GI_INVOLVEMENT_PART
(SID, GI, PARTICIPANT_VERSION, RE_INTERVIEW, COMMENTS, 
 INTERVIEW_DATE, DD2701, INTERVIEW_ADDR, ADDRESS_1, ADDRESS_2, 
 CITY, PROVINCE, STATE, POSTAL_CODE, COUNTRY, 
 GEO_COORDS)
AS 
select gii.sid, gii.gi, gii.participant_version, gii.re_interview, 
           gii.comments, gii.interview_date, gii.dd2701,
           osi_address.get_addr_fields(gii.interview_addr) as interview_addr,
           a.address_1, a.address_2, a.city, a.province, a.state, 
           a.postal_code, a.country, a.geo_coords
      from T_OSI_A_GI_INVOLVEMENT gii, T_OSI_ADDRESS a
     where gii.interview_addr = a.sid(+)
/


CREATE OR REPLACE TRIGGER "OSI_GIINVOLV_PART_IO_IUD_01" 
    instead of insert or update or delete
    ON V_OSI_GI_INVOLVEMENT_PART     for each row
declare
   v_new_sid   varchar2(20);
   v_addr_sid  varchar2(20);
begin 
  if inserting then
    insert into t_osi_a_gi_involvement(gi,participant_version,re_interview,comments,interview_date,dd2701)
           values(:new.gi,
                  :new.participant_version,
                  :new.re_interview,
                  :new.comments,
                  :new.interview_date,
                  :new.dd2701)
    returning sid
         into v_new_sid;           

    --insert interview address
    insert into t_osi_address
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         province,
                         state,
                         postal_code,
                         country,
                         geo_coords)
                 values (:new.gi,
                         osi_address.GET_ADDR_TYPE(core_obj.lookup_objtype('ACT.INTERVIEW.GROUP'), 
                                                                            'PART_LOCATION', 'PART_LOC'),
                         :new.address_1,
                         :new.address_2,
                         :new.city,
                         :new.province,
                         :new.state,
                         :new.postal_code,
                         :new.country,
                         :new.geo_coords)
              returning sid
                   into v_addr_sid;

    update t_osi_a_gi_involvement set interview_addr = v_addr_sid where sid = v_new_sid;
  
  elsif updating then

     begin
         select interview_addr
           into v_addr_sid
           from t_osi_a_gi_involvement
          where sid =  :new.sid;
     exception
          when NO_DATA_FOUND then
               v_addr_sid := null;
     end;

     update t_osi_a_gi_involvement
           set participant_version = :new.participant_version,
               re_interview = :new.re_interview,
               comments = :new.comments,
               interview_date = :new.interview_date,
               dd2701 = :new.dd2701
         where SID = :new.SID
           and (   nvl(participant_version, 'x') <> nvl(:new.participant_version, 'x')
                or nvl(re_interview, 'x') <> nvl(:new.re_interview, 'x')
                or nvl(comments, 'x') <> nvl(:new.comments, 'x')
                or nvl(interview_date, sysdate) <> nvl(:new.interview_date, sysdate)
                or nvl(dd2701, 'x') <> nvl(:new.dd2701, 'x')
                );

        --update (or insert) interview address
        if v_addr_sid is null then
            --insert interview address
            insert into t_osi_address
                    (obj,
                     address_type,
                     address_1,
                     address_2,
                     city,
                     province,
                     state,
                     postal_code,
                     country,
                     geo_coords)
             values (:new.gi,
                     osi_address.GET_ADDR_TYPE(core_obj.lookup_objtype('ACT.INTERVIEW.GROUP'), 
                                                                        'PART_LOCATION', 'PART_LOC'),
                     :new.address_1,
                     :new.address_2,
                     :new.city,
                     :new.province,
                     :new.state,
                     :new.postal_code,
                     :new.country,
                     :new.geo_coords)
               returning sid
               into v_addr_sid;

             update t_osi_a_gi_involvement set interview_addr = v_addr_sid where sid = :new.sid;
        else
             update t_osi_address 
                set address_1 = :new.address_1,
                    address_2 = :new.address_2,
                    city = :new.city,
                    province = :new.province,
                    state = :new.state,
                    postal_code = :new.postal_code,
                    country = :new.country,
                    geo_coords = :new.geo_coords
              where sid = v_addr_sid
                and (    nvl(address_1, 'x') <> nvl(:new.address_1, 'x')
                      or nvl(address_2, 'x') <> nvl(:new.address_2, 'x')
                      or nvl(city, 'x') <> nvl(:new.city, 'x')
                      or nvl(province, 'x') <> nvl(:new.province, 'x')
                      or nvl(state, 'x') <> nvl(:new.state, 'x')
                      or nvl(postal_code, 'x') <> nvl(:new.postal_code, 'x')
                      or nvl(country, 'x') <> nvl(:new.country, 'x')
                      or nvl(geo_coords, 'x') <> nvl(:new.geo_coords, 'x')
                     );
        end if;
  else --must be deleting

       begin
         select interview_addr
           into v_addr_sid
           from t_osi_a_gi_involvement
          where sid =  :old.sid;
       exception
          when NO_DATA_FOUND then
               v_addr_sid := null;
       end;

       delete from t_osi_address where sid = v_addr_sid;
       -- > will cascade delete the t_osi_a_gi_involvement record
       -- > delete from t_osi_a_gi_involvement where sid = :old.sid;
  end if;

  core_obj.bump(:new.SID);
end;
/