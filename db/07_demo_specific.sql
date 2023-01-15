select *
from start_version_update('1', 'Initial version', _component := 'demo_specific');

/***
 *    ██╗███╗---██╗██╗████████╗██╗-█████╗-██╗---------██████╗--█████╗-████████╗-█████╗-
 *    ██║████╗--██║██║╚══██╔══╝██║██╔══██╗██║---------██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
 *    ██║██╔██╗-██║██║---██║---██║███████║██║---------██║--██║███████║---██║---███████║
 *    ██║██║╚██╗██║██║---██║---██║██╔══██║██║---------██║--██║██╔══██║---██║---██╔══██║
 *    ██║██║-╚████║██║---██║---██║██║--██║███████╗----██████╔╝██║--██║---██║---██║--██║
 *    ╚═╝╚═╝--╚═══╝╚═╝---╚═╝---╚═╝╚═╝--╚═╝╚══════╝----╚═════╝-╚═╝--╚═╝---╚═╝---╚═╝--╚═╝
 *    ---------------------------------------------------------------------------------
 */


create
    or replace function load_permission_initial_data()
    returns setof int
    language plpgsql
as
$$
declare
    __group_id int;
begin

    perform unsecure.create_perm_set_as_system('Primary tenant member', null, true, _is_assignable := true,
                                               _permissions := array ['system.manage_tenants.get_groups'
                                                   , 'system.manage_tenants.get_users']);
    perform unsecure.create_user_group('initial_script', 1, 'Default primary tenant members', 1, true, true, false, false, true);
    perform unsecure.assign_permission_as_system(1,4,null,'primary_tenant_member');
end


$$;

select *
from load_permission_initial_data();

select *
from stop_version_update('1', 'demo_specific');