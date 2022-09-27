require 'yaml'

# save module for game
module Save
  def self.create_dir
    Dir.mkdir 'saved' unless Dir.exist? 'saved'
  end

  def self.make_save_file(obj)
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
# tried to turn yml obj to obj
# class Load

#   def self.ask_for_saved_game
#     ask_file_num = gets.chomp
#     file = File.open("#{Dir.pwd}/saved/#{ask_file_num}_save_file.yml")
#     data = YAML.safe_load_file file
    
    
#   end

#   def self.load_game; end
# end

# Load.ask_for_saved_game
