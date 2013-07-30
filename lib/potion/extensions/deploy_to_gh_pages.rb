module Potion::Deployers
  def deploy_to_gh_pages(source_dir)
    original_branch = `git status`.match(/# On branch (?<branch>\S*)/)['branch']
    
    base_dir = `pwd`.strip
    tmp_file_path = "/tmp/potion_#{Time.now.to_i}"
    FileUtils.mkdir_p(tmp_file_path)
    FileUtils.cp_r(File.join(source_dir, "."), tmp_file_path)
    
    File.open(File.join(tmp_file_path, "potion_deploy.txt"), "w+") do |file|
      file.puts "Built and deployed by Potion on: #{Time.now}"
    end
    
    switch_branches = `git checkout gh-pages 2>&1`.strip
    raise "Could not switch branches: \n#{switch_branches}" unless switch_branches.include?("Switched to branch 'gh-pages'") 
    
    delete_current_files = `rm -rf * 2>&1`.strip
    raise "Error clearing out old files: \n#{delete_current_files}" unless delete_current_files == ""
    
    FileUtils.cp_r(File.join(tmp_file_path, "."), base_dir)
    
    `git add .`
    `git commit -a -m "Automatic commit by Potion as part of deploy: #{Time.now}"`
    
    puts "*** Pushing to: origin/gh-pages"
    `git push origin gh-pages`
    
    puts
    
    `git checkout #{original_branch}`
    puts "\n*** Deploy complete."
  end
end