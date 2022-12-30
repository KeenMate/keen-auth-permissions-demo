do
$$
    -- ensure user role
    begin
        if not exists(select * from pg_roles where rolname = 'keen_auth_permissions_demo') then
            create role keen_auth_permissions_demo with password 'Password3000!!' login;
        end if;
    end;
$$;

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'keen_auth_permissions_demo'
  AND pid <> pg_backend_pid();

drop database if exists keen_auth_permissions_demo;
create database keen_auth_permissions_demo with owner keen_auth_permissions_demo;
