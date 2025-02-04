ALTER TABLE T_DIBRS_OFFENSE_TYPE ADD NOTIFICATION VARCHAR2(10);

---------------------
---- Death Cases ----
---------------------
update t_dibrs_offense_type set notification='DEATH' 
  where code like '0000A%' or nibrs_code like '09%';
commit;

-------------------
---- Sex Cases ----
-------------------
update t_dibrs_offense_type set notification='SEX' 
  where code like '120%'
     or code like '125%'
     or code in('134-B1', '134-B5', '134-B6')
     or code in('134-R1', '134-R2', '134-R5')
     or code in('134-C1');
commit;

---------------------
---- Fraud Cases ----
---------------------
update t_dibrs_offense_type set notification='FRAUD' 
  where code in('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-', '083-A-', '083-B-')
   or code in ('123AA1','123AA2','134-E1','134-Q1','134-Q3','180038','180286','180287','181002','181029','181030','181031','181341','181343','181920','26A','26B','26E');
commit;


-----------------------
---- Violent Cases ----
-----------------------
update t_dibrs_offense_type set notification='VIOLENT' 
  where (   (description like 'ASSAULT:%' and code <> '134-C1')
                        or code like '114%'
                        or code like '124%');
commit;
