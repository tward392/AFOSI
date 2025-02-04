-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE BODY osi_address
AS
   /******************************************************************************
      Name:     OSI_ADDRESS
      Purpose:  Provides functions on addresses.

      Revisions:
       Date        Author          Description
       ----------  --------------  ------------------------------------
       23-APR-2009 T.Whitehead    Created package.
       07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                                  UPDATE_ADDRESS, INSERT_ADDRESS)
       22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
       25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                                  updating of an address, if either are applicable.
       30-Jun-2009 T.McGuffin     Moved functionality to its own package from osi_util and osi_object.
       19-Nov-2009 T.Whitehead    Added get_addr_type.
       19-Mar-2010 R.Dibble       Added insert_address - Function
       10-NOV-2010 C.Purcell      Added ADDRESS_WIDGET_OBJS function that is used
                                  in the address widget query.
       07-Feb-2011 Tim Ward       Changed IF V_OBJ IS NULL to IF V_OBJ IS NOT NULL so we get addresses
                                  of the object in the recent addresses list in address_widget_objs.
                                  Also added Group Interview Involvement and all Participant/Participant Version
                                  sids to the return of address_widget_objs.
                                  Added Evidence Obtained At Addresses.
                                  Fixed the Include_Sids so it works.
      
   ******************************************************************************/
   c_pipe   VARCHAR2 (100)
               := core_util.get_config ('CORE.PIPE_PREFIX') || 'OSI_ADDRESS';

   PROCEDURE log_error (p_msg IN VARCHAR2)
   IS
   BEGIN
      core_logger.log_it (c_pipe, p_msg);
   END log_error;

   FUNCTION get_address_sid (p_obj IN VARCHAR2, p_usage IN VARCHAR2 := NULL)
      RETURN VARCHAR2
   IS
      v_rtn   t_osi_address.sid%TYPE;
   BEGIN
      IF p_obj IS NOT NULL
      THEN
         FOR i
            IN (  SELECT a.sid
                    FROM t_osi_address a, t_osi_addr_type at
                   WHERE     a.address_type = at.sid
                         AND a.obj = p_obj
                         AND (at.usage = p_usage OR p_usage IS NULL)
                ORDER BY a.create_on DESC)
         LOOP
            RETURN i.sid;
         END LOOP;
      END IF;

      RETURN v_rtn;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('get_address_sid: ' || SQLERRM);
         RAISE;
   END get_address_sid;

   FUNCTION get_addr_fields (p_sid IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_addr_list      VARCHAR2 (4000);
      v_addr1          t_osi_address.address_1%TYPE;
      v_addr2          t_osi_address.address_2%TYPE;
      v_city           t_osi_address.city%TYPE;
      v_state          t_osi_address.state%TYPE;
      v_state_code     t_dibrs_state.code%TYPE;
      v_province       t_osi_address.province%TYPE;
      v_zip            t_osi_address.postal_code%TYPE;
      v_country        t_osi_address.country%TYPE;
      v_country_code   t_dibrs_country.code%TYPE;
      v_geo_coords     t_osi_address.geo_coords%TYPE;

      PROCEDURE add_item (p_item VARCHAR2)
      IS
         v_result   BOOLEAN;
      BEGIN
         v_result := core_list.add_item_to_list (p_item, v_addr_list);
      END add_item;
   BEGIN
      v_addr_list := NULL;

      IF p_sid IS NOT NULL
      THEN
         SELECT a.address_1,
                a.address_2,
                a.city,
                a.state,
                a.province,
                a.postal_code,
                a.country,
                a.geo_coords
           INTO v_addr1,
                v_addr2,
                v_city,
                v_state,
                v_province,
                v_zip,
                v_country,
                v_geo_coords
           FROM t_osi_address a, t_dibrs_country c
          WHERE c.sid(+) = a.country AND a.sid = p_sid;

         add_item (v_addr1);
         add_item (v_addr2);
         add_item (v_city);
         add_item (v_state);
         add_item (v_zip);
         add_item (v_country);
         add_item (v_province);
         add_item (v_geo_coords);
      END IF;

      RETURN v_addr_list;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('get_addr_fields: ' || SQLERRM);
         RETURN 'get_addr_fields: Error';
   END get_addr_fields;

   FUNCTION get_addr_display (p_address     IN VARCHAR2,
                              p_usage       IN VARCHAR2 := NULL,
                              p_separator   IN VARCHAR2 := NULL)
      RETURN VARCHAR2
   IS
      v_address_display   VARCHAR2 (4000);
      v_addr1             t_osi_address.address_1%TYPE;
      v_addr2             t_osi_address.address_2%TYPE;
      v_city              t_osi_address.city%TYPE;
      v_state             t_osi_address.state%TYPE;
      v_state_code        t_dibrs_state.code%TYPE;
      v_province          t_osi_address.province%TYPE;
      v_zip               t_osi_address.postal_code%TYPE;
      v_country           t_osi_address.country%TYPE;
      v_country_desc      t_dibrs_country.description%TYPE;
      v_separator         VARCHAR2 (20)
                             := NVL (p_separator, CHR (13) || CHR (10));
   BEGIN
      IF p_address IS NULL
      THEN
         RETURN NULL;
      ELSIF NVL (p_usage, 'SID') = 'SID'
      THEN
         SELECT a.address_1,
                a.address_2,
                a.city,
                a.state,
                a.province,
                a.postal_code,
                DECODE (c.code, 'US', NULL, a.country) country
           INTO v_addr1,
                v_addr2,
                v_city,
                v_state,
                v_province,
                v_zip,
                v_country
           FROM t_osi_address a, t_dibrs_country c
          WHERE c.sid(+) = a.country AND a.sid = p_address;
      ELSE
         v_addr1 := core_list.get_list_element (p_address, 1);
         v_addr2 := core_list.get_list_element (p_address, 2);
         v_city := core_list.get_list_element (p_address, 3);
         v_state := core_list.get_list_element (p_address, 4);
         v_zip := core_list.get_list_element (p_address, 5);
         v_country := core_list.get_list_element (p_address, 6);
         v_province := core_list.get_list_element (p_address, 7);
      END IF;

      IF v_addr1 IS NOT NULL
      THEN
         v_address_display := v_address_display || v_addr1 || v_separator;
      END IF;

      IF v_addr2 IS NOT NULL
      THEN
         v_address_display := v_address_display || v_addr2 || v_separator;
      END IF;

      IF v_city IS NOT NULL
      THEN
         v_address_display := v_address_display || v_city || ', ';
      END IF;

      IF v_state IS NOT NULL
      THEN
         SELECT code
           INTO v_state_code
           FROM t_dibrs_state
          WHERE sid = v_state;

         v_address_display := v_address_display || v_state_code || ' ';
      END IF;

      IF v_province IS NOT NULL
      THEN
         v_address_display := v_address_display || v_province || ' ';
      END IF;

      IF v_zip IS NOT NULL
      THEN
         v_address_display := v_address_display || v_zip || v_separator;
      END IF;

      IF v_country IS NOT NULL
      THEN
         BEGIN
            SELECT description
              INTO v_country_desc
              FROM t_dibrs_country
             WHERE sid = v_country AND code <> 'US';

            v_address_display := v_address_display || v_country_desc;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;

      RETURN RTRIM (v_address_display, ',' || v_separator);
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('get_addr_display: ' || SQLERRM);
         RETURN 'get_addr_display: Error';
   END get_addr_display;

   FUNCTION get_addr_type (p_obj_type   IN VARCHAR2,
                           p_usage      IN VARCHAR2,
                           p_code       IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      FOR x
         IN (SELECT sid
               FROM t_osi_addr_type
              WHERE     obj_type = p_obj_type
                    AND usage = p_usage
                    AND code = p_code
                    AND active = 'Y')
      LOOP
         RETURN x.sid;
      END LOOP;

      RETURN NULL;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('get_addr_type: ' || SQLERRM);
   END get_addr_type;

   FUNCTION get_country_code (p_address IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_country   t_dibrs_country.sid%TYPE;
   BEGIN
      v_country := core_list.get_list_element (p_address, 6);

      IF (v_country IS NOT NULL)
      THEN
         FOR x IN (SELECT code
                     FROM t_dibrs_country
                    WHERE sid = v_country)
         LOOP
            RETURN x.code;
         END LOOP;
      END IF;

      RETURN NULL;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('get_country_code: ' || SQLERRM);
   END get_country_code;

   PROCEDURE update_address (p_sid IN VARCHAR2, p_address IN VARCHAR2)
   IS
   BEGIN
      UPDATE t_osi_address
         SET address_1 = core_list.get_list_element (p_address, 1),
             address_2 = core_list.get_list_element (p_address, 2),
             city = core_list.get_list_element (p_address, 3),
             state = core_list.get_list_element (p_address, 4),
             postal_code = core_list.get_list_element (p_address, 5),
             country = core_list.get_list_element (p_address, 6),
             province = core_list.get_list_element (p_address, 7),
             geo_coords = core_list.get_list_element (p_address, 8)
       WHERE sid = p_sid;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('update_address: ' || SQLERRM);
         RAISE;
   END update_address;

   PROCEDURE insert_address (p_obj         IN VARCHAR2,
                             p_addr_type   IN VARCHAR2,
                             p_address     IN VARCHAR2)
   IS
   BEGIN
      INSERT INTO t_osi_address (obj,
                                 address_type,
                                 address_1,
                                 address_2,
                                 city,
                                 state,
                                 postal_code,
                                 country,
                                 province,
                                 geo_coords)
           VALUES (p_obj,
                   p_addr_type,
                   core_list.get_list_element (p_address, 1),
                   core_list.get_list_element (p_address, 2),
                   core_list.get_list_element (p_address, 3),
                   core_list.get_list_element (p_address, 4),
                   core_list.get_list_element (p_address, 5),
                   core_list.get_list_element (p_address, 6),
                   core_list.get_list_element (p_address, 7),
                   core_list.get_list_element (p_address, 8));
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('insert_address: ' || SQLERRM);
         RAISE;
   END insert_address;

   FUNCTION insert_address (p_obj         IN VARCHAR2,
                            p_addr_type   IN VARCHAR2,
                            p_address     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_return   t_osi_address.sid%TYPE;
   BEGIN
      INSERT INTO t_osi_address (obj,
                                 address_type,
                                 address_1,
                                 address_2,
                                 city,
                                 state,
                                 postal_code,
                                 country,
                                 province,
                                 geo_coords)
           VALUES (p_obj,
                   p_addr_type,
                   core_list.get_list_element (p_address, 1),
                   core_list.get_list_element (p_address, 2),
                   core_list.get_list_element (p_address, 3),
                   core_list.get_list_element (p_address, 4),
                   core_list.get_list_element (p_address, 5),
                   core_list.get_list_element (p_address, 6),
                   core_list.get_list_element (p_address, 7),
                   core_list.get_list_element (p_address, 8))
        RETURNING sid
             INTO v_return;

      RETURN v_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('osi_address.insert_address - Function: ' || SQLERRM);
         RAISE;
   END insert_address;

   PROCEDURE update_single_address (p_obj          IN VARCHAR2,
                                    p_addr_usage   IN VARCHAR2,
                                    p_address      IN VARCHAR2)
   IS
      v_tmp_addr    t_osi_address.sid%TYPE;
      v_addr_type   t_osi_addr_type.sid%TYPE;
   BEGIN
      -- get current address sid, if one exists
      v_tmp_addr := get_address_sid (p_obj, p_addr_usage);

      -- if updating
      IF v_tmp_addr IS NOT NULL
         AND (NVL (p_address, 'null') <>
                 NVL (get_addr_fields (v_tmp_addr), 'null'))
      THEN
         UPDATE t_osi_address
            SET address_1 = core_list.get_list_element (p_address, 1),
                address_2 = core_list.get_list_element (p_address, 2),
                city = core_list.get_list_element (p_address, 3),
                state = core_list.get_list_element (p_address, 4),
                postal_code = core_list.get_list_element (p_address, 5),
                country = core_list.get_list_element (p_address, 6),
                province = core_list.get_list_element (p_address, 7),
                geo_coords = core_list.get_list_element (p_address, 8)
          WHERE sid = v_tmp_addr;
      -- if inserting
      ELSIF v_tmp_addr IS NULL AND p_address IS NOT NULL
      THEN
         SELECT sid
           INTO v_addr_type
           FROM t_osi_addr_type
          WHERE obj_type = core_obj.get_objtype (p_obj)
                AND usage = p_addr_usage;

         INSERT INTO t_osi_address (obj,
                                    address_type,
                                    address_1,
                                    address_2,
                                    city,
                                    state,
                                    postal_code,
                                    country,
                                    province,
                                    geo_coords)
              VALUES (p_obj,
                      v_addr_type,
                      core_list.get_list_element (p_address, 1),
                      core_list.get_list_element (p_address, 2),
                      core_list.get_list_element (p_address, 3),
                      core_list.get_list_element (p_address, 4),
                      core_list.get_list_element (p_address, 5),
                      core_list.get_list_element (p_address, 6),
                      core_list.get_list_element (p_address, 7),
                      core_list.get_list_element (p_address, 8));
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ('update_address: ' || SQLERRM);
         RAISE;
   END update_single_address;

   FUNCTION ADDRESS_WIDGET_OBJS (P_OBJ            IN VARCHAR2,
                                 P_USER           IN VARCHAR2,
                                 P_INCLUDE_SIDS   IN VARCHAR2 := NULL)
      RETURN osiAddressWidgetTable
      PIPELINED
   IS
      V_SID_LIST        VARCHAR2 (32000) := NULL;
      V_OBJ             VARCHAR2 (32) := NULL;
      V_USER            VARCHAR2 (32) := NULL;
      V_INCLUDE_SIDS    VARCHAR2 (32000) := NULL;
      V_QUERY           VARCHAR2 (32000) := '';
      V_INCLUDE_COUNT   NUMBER := 0;
      
   BEGIN
      V_OBJ := P_OBJ;
      V_USER := P_USER;
      V_INCLUDE_SIDS := P_INCLUDE_SIDS;

      --- OBJ IS SPECIFIED ---
      IF V_OBJ IS NOT NULL
      THEN
         PIPE ROW (osiAddressWidget (V_OBJ));
      END IF;
      
      --- if there is only one include sid, use it as V_OBJ ---
      IF V_OBJ IS NULL THEN

        SELECT count(*) into v_include_count FROM TABLE(SPLIT(v_include_sids,'~')) where column_value is not null;
        
        if v_include_count = 1 then
          
          V_OBJ := replace(v_include_sids,'~','');
          
        end if;
        
      END IF;
      
      --- OBJ IS PERSONNEL ADDRESSES ---
      FOR I
         IN (SELECT OBJ
               FROM T_OSI_ADDRESS
              WHERE OBJ = V_USER
                    AND address_type <>
                           osi_address.
                            get_addr_type (
                              core_obj.lookup_objtype ('PERSONNEL'),
                              'BIRTH',
                              'BIRTH')
                    AND address_type <>
                           osi_address.
                            get_addr_type (
                              core_obj.lookup_objtype ('PERSONNEL'),
                              'PERM',
                              'PERM'))
      LOOP
         PIPE ROW (osiAddressWidget (I.OBJ));
      END LOOP;

      --- UNIT --
      PIPE ROW (osiAddressWidget (osi_personnel.get_current_unit (V_USER)));

      --- INCLUDED SIDS --
      FOR I IN (SELECT * FROM TABLE(SPLIT(v_include_sids,'~')) WHERE COLUMN_VALUE IS NOT NULL)
      LOOP
          PIPE ROW (osiAddressWidget (I.COLUMN_VALUE));
          
      END LOOP;

      --- Involvement ---
      FOR I
         IN (SELECT pa.address, pi.participant_version
               FROM t_osi_partic_involvement pi, t_osi_partic_address pa
              WHERE pi.participant_version=pa.participant_version(+)
                    AND (pi.obj = NVL (V_OBJ, 'x')))
      LOOP
          FOR J
             IN (SELECT sid, participant
                   FROM t_osi_participant_version 
                  where participant in (select participant from t_osi_participant_version where sid=i.PARTICIPANT_VERSION))
          LOOP
              PIPE ROW (osiAddressWidget (J.SID));
              PIPE ROW (osiAddressWidget (J.PARTICIPANT));
         
          END LOOP;
         
      END LOOP;

      --- Group Interview involvement ---
      FOR I
         IN (SELECT pa.address, pi.participant_version
               FROM t_osi_a_gi_involvement pi, t_osi_partic_address pa
              WHERE pi.participant_version=pa.participant_version(+)
                    AND (pi.gi = NVL (V_OBJ, 'x') ))
      LOOP
          FOR J
             IN (SELECT sid, participant
                   FROM t_osi_participant_version 
                  where participant in (select participant from t_osi_participant_version where sid=i.PARTICIPANT_VERSION))
          LOOP
              PIPE ROW (osiAddressWidget (J.SID));
              PIPE ROW (osiAddressWidget (J.PARTICIPANT));
         
          END LOOP;
         
      END LOOP;
      
      --- Evidence Obtained At Addresss ---
      FOR I
         IN (SELECT e.sid
               FROM t_osi_evidence e, t_osi_activity a
              WHERE a.sid=e.obj and a.sid=v_obj)
      LOOP
          PIPE ROW (osiAddressWidget (I.SID));

      END LOOP;
      
      FOR i IN (SELECT assigned_unit sid
                  FROM t_osi_activity
                 WHERE sid = V_OBJ
                UNION ALL
                SELECT creating_unit sid
                  FROM t_osi_activity
                 WHERE sid = V_OBJ
                UNION ALL
                SELECT unit_sid sid
                  FROM t_osi_f_unit
                 WHERE file_sid = V_OBJ
                UNION ALL
                SELECT osi_personnel.get_current_unit (sid) AS sid
                  FROM t_osi_personnel
                 WHERE sid = V_OBJ
                UNION ALL
                SELECT sid
                  FROM t_osi_participant_version
                 WHERE participant = V_OBJ
                UNION ALL
                SELECT sid
                  FROM t_osi_participant_version
                 WHERE participant = osi_participant.get_participant(V_OBJ) ---All Participant Version SIDS
                UNION ALL
                SELECT partic_a SID
                  FROM t_osi_partic_relation
                 WHERE partic_b = V_OBJ
                UNION
                SELECT partic_b SID
                  FROM t_osi_partic_relation
                 WHERE partic_a = V_OBJ)
      LOOP
         PIPE ROW (osiAddressWidget (I.SID));
      END LOOP;

      RETURN;
   END ADDRESS_WIDGET_OBJS;
END osi_address;
/