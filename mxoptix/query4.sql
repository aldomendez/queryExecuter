select * from dare_pkg.mv_pkg10gfunct_rpt
where work_day=to_char(sysdate-1,'Mon-dd')
