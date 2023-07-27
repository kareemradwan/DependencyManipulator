require 'xcodeproj'

begin
  project_path = ARGV[0]
  new_bundle_id = ARGV[1]
  build_config_name = ARGV[2]

  project = Xcodeproj::Project.open(project_path)

  project.targets.each do |target|
  target.build_configurations.each do |config|
    if config.name == build_config_name
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = new_bundle_id
    end
  end
  end

project.save

puts "Project Saved"

rescue Exception => e
  puts "An error occurred: #{e.message}"
end
