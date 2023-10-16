select * from public.mcastatus;
select * from public.mcastatus where status in ('Funded', 'Completed');
select * from gfeny.mcaposition;

select * from gfeny.mcaposition where mcaid in (73772,80674,65995,38753);
update gfeny.mcaposition set status=295 where mcaid in (73772,80674,65995,38753);
commit;