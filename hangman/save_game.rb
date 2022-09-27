require 'yaml'

# save module for game
module Save

  def Save.create_dir
    Dir.mkdir 'saved' unless Dir.exist? 'saved'
  end

  def Save.make_save_file(obj)
    s = Dir.pwd
    dir = s << '/saved'
    p dir
    dir_size = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }
    file_name = "#{dir_size + 1}_save_file.yml"
    saved_file = File.open("#{dir}/#{file_name}", 'w')
    YAML.dump(obj, saved_file)
    file_name
  end

end
