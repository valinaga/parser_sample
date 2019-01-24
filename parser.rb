#!/usr/bin/env ruby

class Parser
  # accept the filename as input in args
  def initialize(args)
    @file_name = args.first
    @paths = {}
  end  

  # read and parse the file with the name got as argument
  # check if argument exists and file also exists
  def run
    if !@file_name
      puts "You need to provide the log file name.\n\n\tSyntax: ./parser <filename>\n\n"
    elsif !File.exists?(@file_name)
      puts "File provided was not found. Check the file name.\n\n"
    else
      parse()
      puts "\nTOTAL VIEWS\n-----------"
      puts total_visits
      puts "\n\nUNIQUE VIEWS\n------------"
      puts uniq_visits
    end
  end

  # parse   
  def parse()
    File.readlines(@file_name).each do |line|
      # split the line
      path, ip = line.split

      # nothing to do if path or source is nil
      continue if path.nil? || ip.nil?

      # use Hash to maintain unique paths and unique sources within paths
      if @paths[path]
        @paths[path][:visits] += 1 
        local_ips = @paths[path][:sources]
        if local_ips[ip]
          local_ips[ip] += 1
        else
          local_ips[ip] = 1
        end
      else
        @paths[path] = { visits: 1, sources: Hash[ip, 1] }
      end
    end

    # process unique views from paths sources, drop sources once completed
    @paths.each do |k,v| 
      @paths[k][:uniq] = v[:sources].keys.count 
      @paths[k].delete(:sources)
    end
  end

  # helper method to get the paths
  def data
    @paths
  end

  # method to sort keys of hash in reverse order for sym :visits or :uniq
  def sorted(sym)
    @paths.keys.sort{|a, b| @paths[b][sym] <=> @paths[a][sym]}
  end

  # method to output most viewed pages based on sym :uniq or visited
  def visits(sym)
    sorted(sym).map{|v| "#{v.ljust(20, ' ')} #{@paths[v][sym]} #{sym == :uniq ? 'unique views' : 'visits'}"}
  end

  # helper method for total visits
  def total_visits
    visits(:visits)
  end

  # helper method for unique views
  def uniq_visits
    visits(:uniq)
  end
end

# Use Ruby constants to make the file runnable from the command line
if $PROGRAM_NAME == __FILE__
  Parser.new(ARGV).run
end