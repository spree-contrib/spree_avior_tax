Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_configuration',
  name: 'add_avior_tax_admin_menu_link',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item 'Avior Tax Settings', edit_admin_avior_tax_settings_path if can? :manage, Spree::Config %>"
)
