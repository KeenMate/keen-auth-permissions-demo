/***
 *    ███████╗██╗    ██╗██╗████████╗ ██████╗██╗  ██╗    ███████╗ ██████╗██╗  ██╗███████╗███╗   ███╗ █████╗
 *    ██╔════╝██║    ██║██║╚══██╔══╝██╔════╝██║  ██║    ██╔════╝██╔════╝██║  ██║██╔════╝████╗ ████║██╔══██╗
 *    ███████╗██║ █╗ ██║██║   ██║   ██║     ███████║    ███████╗██║     ███████║█████╗  ██╔████╔██║███████║
 *    ╚════██║██║███╗██║██║   ██║   ██║     ██╔══██║    ╚════██║██║     ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══██║
 *    ███████║╚███╔███╔╝██║   ██║   ╚██████╗██║  ██║    ███████║╚██████╗██║  ██║███████╗██║ ╚═╝ ██║██║  ██║
 *    ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝
 *
 *    TO km_common_helpers database
 */

create schema if not exists error;
create schema if not exists const;
create schema if not exists unsecure; -- functions without any permission validation
create schema if not exists helpers;
create schema if not exists ext;
create schema if not exists auth;

alter default privileges
    in schema public, auth, const
    grant select, insert, update, delete on tables to keen_auth_permissions_demo;
alter default privileges
    in schema const, unsecure, error, ext, auth, helpers grant usage, select on sequences to keen_auth_permissions_demo;

alter role keen_auth_permissions_demo set search_path to public, const, ext, helpers, unsecure, auth;
set search_path = public, const, ext, helpers, unsecure, auth;
ALTER DATABASE keen_auth_permissions_demo SET search_path TO public, ext, helpers, unsecure, auth;