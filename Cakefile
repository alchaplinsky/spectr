{exec} = require "child_process"

task 'build', ->
  exec "coffee -cp src/spectr.coffee >> spectr.js"
  
task 'watch', ->
  exec "coffee -o ./ -cw src/"