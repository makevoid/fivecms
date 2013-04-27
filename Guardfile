guard 'sass', input: 'sass', output: 'public/css'
guard 'coffeescript', input: 'coffee', output: "public/js"
guard 'livereload' do
  watch(%r{views/.+.(erb|haml|slim|md|markdown)})
  watch(%r{public/css/.+.css})
  watch(%r{public/js/.+.js})
end

guard :relaunch, command: "rackup -p 3000", kill_command: "sudo killall -9 rackup", watch: /\.rb/