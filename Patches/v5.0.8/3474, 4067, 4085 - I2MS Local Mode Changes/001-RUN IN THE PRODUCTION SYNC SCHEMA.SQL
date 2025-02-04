alter table t_version add start_date date;
alter table t_version add end_date date;

update t_version set start_date=to_date('02-Feb-2011','DD-Mon-YYYY') where I2MS='1.0.0.0';
commit;

insert into t_version (i2ms,i2mssync,i2msbsl,start_date) values ('1.1.0.0','1.1.0.0','1.1.0.0',to_date('25-Jul-2012','DD-Mon-YYYY'));
commit;

