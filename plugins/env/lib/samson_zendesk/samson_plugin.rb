module SamsonEnv
  class Engine < Rails::Engine
  end
end

Samson::Hooks.view :stage_form, "samson_env/fields"

Samson::Hooks.callback :stage_permitted_params do
  :env
end

Samson::Hooks.callback :after_deploy_setup do |dir, stage|
  if stage.env.present?
    File.write("#{dir}/.env", stage.env)

    # propriatary manifest format
    manifest = "#{dir}/ENV.json"
    if File.exist?(manifest)
      json = JSON.load(File.read(manifest))
      json.fetch("env").merge!(Dotenv::Parser.call(stage.env))
      File.write(manifest, JSON.pretty_generate(json))
    end
  end
end
