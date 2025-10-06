require 'find'
require 'digest'
require 'json'

def collect_files(root, ignore = [])
  files = []
  Find.find(root) do |path|
    next if File.directory?(path)
    next if File.symlink?(path)
    next if ignore.any? { |pat| path.include?(pat) }

    begin
      stat = File.lstat(path)
      files << { path: path, size: stat.size, inode: stat.ino }
    rescue => e
      warn "Skip #{path}: #{e}"
    end
  end
  files
end

def same_file?(f1, f2)
  return false unless File.size(f1) == File.size(f2)
  File.open(f1, "rb") do |a|
    File.open(f2, "rb") do |b|
      until a.eof?
        return false unless a.read(4096) == b.read(4096)
      end
    end
  end
  true
rescue => e
  warn "Compare failed (#{f1}, #{f2}): #{e}"
  false
end

def find_duplicates(files)
  candidates = files.group_by { |f| f[:size] }
  groups = []

  candidates.each do |size, arr|
    next if arr.size < 2

    # групуємо за MD5
    by_hash = arr.group_by do |f|
      begin
        Digest::MD5.file(f[:path]).hexdigest
      rescue => e
        warn "Hash failed for #{f[:path]}: #{e}"
        nil
      end
    end

    by_hash.each do |hash, fileset|
      next if hash.nil? || fileset.size < 2

      confirmed = []
      first = fileset.first[:path]
      confirmed << first
      fileset.drop(1).each do |f|
        confirmed << f[:path] if same_file?(first, f[:path])
      end

      if confirmed.size > 1
        saved = (confirmed.size - 1) * size
        groups << {
          size_bytes: size,
          saved_if_dedup_bytes: saved,
          files: confirmed
        }
      end
    end
  end

  groups
end

root_dir = ARGV[0] || "."
ignore = []
files = collect_files(root_dir, ignore)
groups = find_duplicates(files)

report = {
  scanned_files: files.size,
  groups: groups
}

File.write("duplicates.json", JSON.pretty_generate(report))
puts "Звіт збережено у duplicates.json"
