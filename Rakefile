# exit gracefully
trap('SIGINT') { exit(0) }
trap('SIGTERM') { exit(0) }

task :run do
  ruby './bin/androgee'
end

task :shell do
  sh 'bash'
end

task default: :run
