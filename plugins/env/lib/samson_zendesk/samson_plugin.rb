module SamsonEnv
  class Engine < Rails::Engine
  end
end

Samson::Hooks.view :stage_form, "samson_env/fields"

Samson::Hooks.callback :stage_permitted_params do
  :env
end

Samson::Hooks.callback :after_deploy_setup do |dir, stage|
  File.write("#{dir}/.env", stage.env) if stage.env.present?
end
