guard 'sass', input: 'sass', output: 'public/css'
guard 'coffeescript', input: 'coffee', output: "public/js", bare: true
guard 'coffeescript', input: 'spec', output: "spec/js", bare: true
guard 'livereload' do
  watch(%r{views/.+.(erb|haml|slim|md|markdown|handlebars)})
  watch(%r{views/templates.+.(handlebars)})
  watch(%r{public/css/.+.css})
  watch(%r{public/js/.+.js})
end

guard :relaunch, watch: /\.rb/, command: "rackup -p 3000"#, kill_command: "killall -9 rackup"