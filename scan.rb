load 'Radar.rb'


aliens_found = 0
alien1 = File.open("aliens/alien1.txt")
alien2 = File.open("aliens/alien2.txt")
aliens = Array.new([alien1, alien2])

def radar_file
  valid_file = false
  puts 'please enter a file name'
  while valid_file == false
    begin
      filename = gets.strip
      file = File.open("radar_files/#{filename}")
    rescue
      puts 'please enter correct a file name'
      next
    end
    valid_file = true
  end
  file.read
end

def radar_width(radar)
  radar.file.split("\n").first.length
end

def match_lines(radar, alien)
  line_matches = Array.new()

  alien.read.split("\n").each_with_index do |alien_line, index|
    line_matches[index] = Array.new()
    radar.file.scan(/(#{alien_line})/) do |m|
      line_matches[index] << [$~.offset(0)[0]]
    end
  end
  line_matches
end

def find_aliens(line_matches, radar, aliens_found)
  line_matches[0].each do |first_line_match|
    line_match_count = 1
    line_matches.each_with_index do |line_matches_by_line, line_index|
      next if line_index == 0
      position = Array.new([first_line_match[0] + (radar.width + 1) * line_index])
      if line_matches_by_line.include? position
        line_match_count += 1
        aliens_found += 1 if line_match_count == 8
      end
    end
  end
  return aliens_found
end

radar = Radar.new()
radar.file = radar_file
radar.width = radar_width(radar)

alien1_line_matches = match_lines(radar, alien1)
alien2_line_matches = match_lines(radar, alien2)


aliens_found = find_aliens(alien1_line_matches, radar, aliens_found)
aliens_found = find_aliens(alien2_line_matches, radar, aliens_found)


if aliens_found == 1
  puts "there is #{aliens_found} alien in this radar image"
else
  puts "there are #{aliens_found} aliens in this radar image"
end
