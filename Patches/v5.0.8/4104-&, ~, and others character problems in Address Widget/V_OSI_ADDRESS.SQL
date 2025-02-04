CREATE OR REPLACE VIEW V_OSI_ADDRESS
(SID, OBJ, ADDRESS_TYPE_SID, ADDRESS_TYPE_CODE, STATE_SID, 
 STATE_CODE, COUNTRY_SID, COUNTRY_DESC, CITY, COUNTRY_CODE, 
 DISPLAY_STRING, SINGLE_LINE, FIELDS)
AS 
SELECT oa.SID, oa.obj, oa.address_type AS "ADDRESS_TYPE_SID", oat.code AS "ADDRESS_TYPE_CODE",
           oa.state AS "STATE_SID", ds.code AS "STATE_CODE", oa.country AS "COUNTRY_SID",
           dc.description AS "COUNTRY_DESC",
     oa.city AS "CITY", dc.CODE AS "COUNTRY_CODE",
           RTRIM(DECODE(OA.ADDRESS_1, NULL, NULL, OA.ADDRESS_1 || CHR(13) || CHR(10))
                 || DECODE(OA.ADDRESS_2, NULL, NULL, OA.ADDRESS_2 || CHR(13) || CHR(10))
                 || DECODE(OA.CITY, NULL, NULL, OA.CITY || ', ')
                 || DECODE(ds.code, NULL, NULL, ds.code || ' ')
                 || DECODE(OA.PROVINCE, NULL, NULL, OA.PROVINCE || ' ')
                 || DECODE(OA.postal_code, NULL, NULL, OA.postal_code || CHR(13) || CHR(10))
                 || DECODE(dc.code, NULL, NULL, '105', NULL, 'US', NULL, dc.DESCRIPTION),
                 ', ' || CHR(13) || CHR(10)) AS DISPLAY_STRING,
           (RTRIM(DECODE(oa.address_1, NULL, '', oa.address_1 || ', ')
                  || DECODE(oa.address_2, NULL, '', oa.address_2 || ', ')
                  || DECODE(oa.city, NULL, '', oa.city || ', ')
                  || DECODE(oa.state, NULL, '', ds.description || ', ')
                  || DECODE(oa.postal_code, NULL, '', oa.postal_code || ', ')
                  || DECODE(dc.code, NULL, '', 'US', NULL, dc.description),
                  ', ')) AS single_line,
            '~^~' || oa.address_1 || '~^~' || oa.address_2 || '~^~' || oa.city || '~^~' || oa.state || '~^~' || oa.postal_code || '~^~' || oa.country || '~^~' || oa.province || '~^~' || oa.geo_coords || '~^~' as FIELDS
      FROM T_OSI_ADDRESS oa, T_DIBRS_STATE ds, T_DIBRS_COUNTRY dc, T_OSI_ADDR_TYPE oat
     WHERE oa.state = ds.SID(+) AND oa.country = dc.SID(+) AND oat.SID = oa.address_type
/

