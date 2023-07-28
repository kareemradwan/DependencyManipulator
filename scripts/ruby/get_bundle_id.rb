require 'xcodeproj'
require 'json'

begin
  project_path = ARGV[0]
  puts "Opening project at path: #{project_path}"

  project = Xcodeproj::Project.open(project_path)

 puts "Successfully opened project"

  bundle_ids = {}
  project.targets.each do |target|
    target.build_configurations.each do |config|
      puts "#{config} => #{config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']}"
      bundle_ids[config.name] = config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
    end

    puts JSON.generate(bundle_ids)

  end

rescue Exception => e
  puts "An error occurred: #{e.message}"
end
