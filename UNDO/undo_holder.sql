select s.sid, t.name, s.value,ss.program,ss.terminal,ss.machine,ss.osuser
    from v$sesstat s, v$statname t,v$session ss
    where s.statistic# = t.statistic#
    and SS.SID=s.sid
    and t.name = 'undo change vector size'
    order by s.value desc;