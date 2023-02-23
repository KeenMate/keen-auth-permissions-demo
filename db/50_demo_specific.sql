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
    _user_id bigint;
begin

    perform unsecure.create_perm_set_as_system('Primary tenant member', false, true,
                                               array ['system.manage_tenants.get_groups'
                                                   , 'system.manage_tenants.get_users']);
    perform unsecure.create_user_group('initial_script', 1, 'Default primary tenant members');
    perform unsecure.assign_permission_as_system(1, null, 'primary_tenant_member');


    select __user_id
    from auth.register_user(_created_by := 'create script', _user_id := 1, _email := 'jan.rada@keenmate.com',
                            _password_hash := '$pbkdf2-sha512$160000$1KMvsgmM4aycW/QMWGSnjQ$fArLPtg5d6vDhbzT13wiTnuRjWSafV58QY8nQdgQKgKdgDiv.qeaicfzxK..0aIwPm6ZA1BxlZh8d4h/Ps46gw',
                            _display_name := 'Jan Rada')
    into _user_id;

    perform auth.enable_user_identity('system',1,_user_id,'email');

    perform unsecure.create_user_group_member_as_system('jan.rada@keenmate.com','System admins');

    end


$$;

select *
from load_initial_demo_data();

select *
from stop_version_update('1', 'demo_specific');