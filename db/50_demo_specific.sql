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
    or replace function load_initial_demo_data()
    returns setof int
    language plpgsql
as
$$
declare
    __group_id int;
begin

    perform unsecure.create_perm_set_as_system('Primary tenant member', false, true,
                                                array ['system.manage_tenants.get_groups'
                                                   , 'system.manage_tenants.get_users']);
    perform unsecure.create_user_group('initial_script', 1, 'Default primary tenant members');
    perform unsecure.assign_permission_as_system(1,null,'primary_tenant_member');
end


$$;

select *
from load_initial_demo_data();

select *
from stop_version_update('1', 'demo_specific');